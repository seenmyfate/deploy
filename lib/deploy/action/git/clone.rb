module Deploy
  module Git
    class Clone

      def initialize(app, options={}, &block)
        @app = app
        @repo = options.fetch(:repo)
        @logger = Logger.new("deploy::git")
      end

      def call(env)
        @logger.info "git clone"
        env.session.run([:app,:web, :db], 'cd /var/www/my_app/current; git fetch origin; git reset --hard origin/master', @logger)
        @app.call(env)
      end

      def recover(env)
        @logger.info "recovering"
      end
    end
  end
end
