module Deploy
  class BackendFactory

    def initialize(env)
      @env = env
      @backend_class = validate_backend(env.backend)
    end

    def validate_backend(name)
      Deploy::Backend.const_get(name)
    rescue NameError
      fail 'Backend does not exist'
    end

    def backend
      @backend ||= @backend_class.new(@env)
    end

    def self.for(env)
      new(env).backend
    end
  end
end
