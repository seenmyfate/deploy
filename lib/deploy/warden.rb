# middleware conecpt shown here borrowed pretty much wholesale
# from the very awesome Vagrant
#
# https://github.com/mitchellh/vagrant
#
module Deploy
  class Warden

    def initialize(actions)
      @stack = []
      @logger = Logger.new("deploy::warden")
      @middlewares = actions.map { |action| build(action) }
    end

    def stack
      @stack
    end

    def call(env)
      begin
        if middleware = @middlewares.shift
          @logger.debug("Calling middleware: #{middleware}")
          @stack.unshift(middleware).first.call(env)
        end
      rescue SystemExit
        # just quit
        fail
      rescue Exception => e
        # broke all the things
        # call recover to walk back up the chain recovering
        # if each middleware implements recover (ie recover)
        @logger.error("Error occurred: #{e}")
        recover(env)
      end
    end

    def recover(env)
      @stack.each do |middleware|
        if middleware.respond_to?(:recover)
          @logger.debug("Calling recover: #{middleware}")
          middleware.recover(env)
        end
      end
    end

    def build(action)
      middleware, args, block = action
      middleware.new(self, *args, &block)
    end
  end
end
