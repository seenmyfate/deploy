module Deploy
  module System
    class Check

      def initialize(app, *args, &block)
        @app = app
        @logger = Logger.new("deploy::system")
      end

      def call(env)
        @logger.info "system check"
        env.session.run([:app,:web,:db], "uptime", @logger)
        @app.call(env)
      end

      def recover(env)
        @logger.info "recovering"
      end
    end
  end
end
