require 'spec_helper'

module Deploy
  describe Logger do
    let(:logger) { Logger.new(name) }
    let(:name) { 'deploy' }
    let(:log4r) { stub.as_null_object  }
    let(:outputter) { stub }
    let(:formatter) { stub }
    let(:pattern) { stub }
    let(:color_formatter) { stub }

    before do
      Log4r::Outputter.should_receive(:stdout).and_return(outputter)
      ColorFormatter.should_receive(:new).and_return(color_formatter)
      color_formatter.should_receive(:pattern).and_return(pattern)
      Log4r::PatternFormatter.should_receive(:new).with(pattern:pattern).
        and_return(formatter)
      outputter.should_receive(:formatter=).with(formatter)
      Log4r::Logger.should_receive(:new).with(name).and_return(log4r)
      log4r.should_receive(:outputters=).with(outputter)
      log4r.should_receive(:level=).with(2)
    end

    describe "#new" do
      it "takes a name" do
        logger
      end
    end

    describe "#info" do
      it "delegates to logger" do
        log4r.should_receive(:info).with('info')
        logger.info 'info'
      end
    end

    describe "#debug" do
      it "delegates to logger" do
        log4r.should_receive(:debug).with('debug')
        logger.debug 'debug'
      end
    end

    describe "#error" do
      it "delegates to logger" do
        log4r.should_receive(:error).with('error')
        logger.error 'error'
      end
    end
  end
end
