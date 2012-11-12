module Deploy
  module Unicorn
    class Restart

      def initialize(app, *args, &block)
        @app = app
        @logger = Logger.new("deploy::unicorn")
      end

      def call(env)
        @logger.info "unicorn restart"
        env.session.run(:app, "sudo service my_app restart", @logger)
        @app.call(env)
      end

      def recover(env)
        @logger.info "recovering"
      end
    end
  end
end
