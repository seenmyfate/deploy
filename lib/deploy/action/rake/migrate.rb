module Deploy
  module Rake
    class Migrate

      def initialize(app, *args, &block)
        @app = app
        @logger = Logger.new("deploy::rake")
      end

      def call(env)
        @logger.info "rake db:migrate"
        env.session.run(:app, "cd /var/www/my_app/current; #{migrate(env.rails_env)}", @logger)
        @app.call(env)
      end

      def migrate(rails_env)
        "bundle exec rake RAILS_ENV=#{rails_env} db:migrate"
      end

      def recover(env)
        @logger.info "recovering"
      end
    end
  end
end
