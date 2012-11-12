module Deploy
  module Maintenance
    class Off

      def initialize(app, options={}, &block)
        @app = app
        @logger = Logger.new("deploy::maintenance")
      end

      def call(env)
        @logger.info "maintenance off"
        env.session.run([:app,:web, :db],'', @logger) 
        @app.call(env)
      end

      def recover(env)
        @logger.info "recovering"
      end
    end
  end
end
