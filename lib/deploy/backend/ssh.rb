require 'net/ssh/multi'
module Deploy
  module Backend
    class SSH

      include Colors

      def initialize(env)
        @env = env
        @logger  = Logger.new("deploy::ssh")
        add_roles
      end

      def default_user
        @env.user
      end

      def roles
        @env.roles
      end

      def run(role, command, logger)
        roles = Array(role)
        roles.each do |role|
          session.with(role).open_channel do |channel|
            @logger.debug "opening channel #{channel[:host]}"

            channel.request_pty do |_, success|
              @logger.debug 'requesting pty'
              if success
                @logger.debug 'pty request successful'
              else
                @logger.debug 'pty request failed'
                fail 'pty request failed'
              end
            end

            channel.exec command

            # all of the callbacks

            channel.on_data do |ch, data|
              logger.info "[#{role}] #{ch[:host]} #{data.chomp}"
            end

            channel.on_extended_data do |ch, type, data|
              logger.info "[#{role}] #{ch[:host]} #{data.chomp}"
            end

            channel.on_close do |ch|
              @logger.debug "[#{role}] channel #{ch[:host]} is closing"
            end

            channel.on_request "exit-status" do |ch, data|
              exit_status = data.read_long
              if exit_status == 1
                @logger.error "[#{role}] channel #{ch[:host]} command failed"
                fail 'Non zero exit status' if exit_status == 1
              end
            end
          end

        end
        # run the actual command
        session.loop
      end

      def session
        @session ||= Net::SSH::Multi.start
      end

      def add_roles
        session.default_user = default_user
        roles.each do |role, servers|
          session.group role do
            servers.each do |server|
              session.use server
            end
          end
        end
      end
    end
  end
end
