module Deploy
  module Maintenance
    class On

      def initialize(app, options={}, &block)
        @app = app
        @logger = Logger.new("deploy::maintenance")
      end

      def call(env)
        @logger.info "maintenance on"
        env.session.run([:app,:web, :db],'', @logger) 
        @app.call(env)
      end

      def recover(env)
        @logger.info "recovering"
      end
    end
  end
end
