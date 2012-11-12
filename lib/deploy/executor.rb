module Deploy
  class Executor

    def initialize(env)
      @backend = BackendFactory.for(env)
    end

    def run(role, command, logger)
      @backend.run(role, command, logger)
    end
  end
end
