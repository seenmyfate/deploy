module Deploy
  class Logger

    extend Forwardable
    def_delegators :@logger, :debug, :error, :info

    def initialize(name)
      @logger = Log4r::Logger.new(name)
      outputter.formatter = formatter
      @logger.outputters = outputter
      @logger.level = 2
    end

    def outputter
      @outputter ||= Log4r::Outputter.stdout
    end

    def pattern
      @pattern ||= ColorFormatter.new.pattern
    end

    def formatter
      @formatter ||= Log4r::PatternFormatter.new(:pattern => pattern)
    end
  end
end
