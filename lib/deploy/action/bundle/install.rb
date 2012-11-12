module Deploy
  module Bundle
    class Install

      def initialize(app, *args, &block)
        @app = app
        @logger = Logger.new("deploy::bundle")
      end

      def call(env)
        @logger.info "bundle install"
        env.session.run(:app, "cd /var/www/my_app/current; #{bundle}", @logger)
        @app.call(env)
      end

      def bundle
        'bundle install --gemfile /var/www/my_app/current/Gemfile --deployment --binstubs /var/www/my_app/shared/bin --path /var/www/my_app/shared/bundle --without development test cucumber'
      end

      def recover(env)
        @logger.info "recovering"
      end
    end
  end
end
