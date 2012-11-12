module Deploy
  class Runner

    def initialize(env)
      @env = env
      @logger = Logger.new("deploy::runner")
    end

    def run(app)
      @env.session Executor.new(@env)
      @logger.debug("Running deploy: #{app}")
      app.call(@env)
    end
  end
end
