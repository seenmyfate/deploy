module Deploy
  module Backend
    class Heroku
      def initialize(env)
        @roles = env.roles
      end

      def run(role, command, logger)
        roles = Array(role)
        roles.each do |role|
          logger.info "[#{role}] #{@roles[role]} #{command}"
        end
      end
    end
  end
end
