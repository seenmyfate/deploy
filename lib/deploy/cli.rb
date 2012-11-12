require 'highline'
module Deploy
  module CLI
    extend self

    def ui
      @ui ||= HighLine.new
    end
  end
end