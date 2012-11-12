module Deploy
  module File
    class Tree

      def initialize(app, *args, &block)
        @app = app
        @logger = Logger.new("deploy::file")
      end

      def call(env)
        @logger.info "file tree"
        env.session.run([:app,:web,:db], "", @logger)
        @app.call(env)
      end

      def recover(env)
        @logger.info "recovering"
      end
    end
  end
end
