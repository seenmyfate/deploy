module Deploy
  class Builder

    def initialize
      yield self if block_given?
    end

    def use(middleware, *args, &block)
      if middleware.is_a? Builder
        stack.concat middleware.stack
      else
        stack.push [middleware, args, block]
      end
    end

    def stack
      @stack ||= []
    end

    def call(env)
      to_app.call(env)
    end

    def to_app
      Warden.new(stack.dup)
    end
  end
end
