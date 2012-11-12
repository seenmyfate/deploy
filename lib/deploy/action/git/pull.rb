module Deploy
  module Git
    class Pull

      def initialize(app, options={}, &block)
        @app = app
        @repo = options.fetch(:repo)
        @logger = Logger.new("deploy::git")
      end

      def call(env)
        @logger.info "git pull"
        env.session.run([:app,:web, :db], 'cd /var/www/my_app/current; git fetch origin; git reset --hard origin/master', @logger)
        @app.call(env)
      end

      def branch
        CLI.ui.ask("Which branch?  ") { |q| q.default = "master" }
      end

      def recover(env)
        @logger.info "recovering"
      end
    end
  end
end
