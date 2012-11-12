require 'ansi/code'
module Deploy
  module Colors
    def green(string)
      ANSI::Code.green { string }
    end

    def red(string)
      ANSI::Code.red { string }
    end

    def yellow(string)
      ANSI::Code.yellow { string }
    end

    def blue(string)
      ANSI::Code.blue { string }
    end

    def cyan(string)
      ANSI::Code.cyan { string }
    end

    def grey(string)
      ANSI::Code.grey { string }
    end
  end
end