module Deploy
  module File
    class Symlink

      def initialize(app, *args, &block)
        @app = app
        @logger = Logger.new("deploy::file")
      end

      def call(env)
        @logger.info "file symlink"
        env.session.run([:app,:web], "uptime", @logger)
        @app.call(env)
      end

      def recover(env)
        @logger.info "recovering"
      end
    end
  end
end
