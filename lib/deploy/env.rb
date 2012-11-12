module Deploy
  class Env

    def initialize(name)
      @name = name
      @env = {}
      yield self if block_given?
    end

    def method_missing(key, value=nil)
      return set(key, value) if value
      get(key)
    end

    def set(key, value)
      @env[key] = value
    end

    def get(value)
      @env[value]
    end

    def respond_to?(method)
      @env.has_key?(method)
    end

    def role(title, servers)
      roles.merge!(title => servers)
    end

    def roles
      @roles ||= {}
    end
  end
end
