require 'spec_helper'

module Deploy
  describe Runner do

    let(:runner) { Runner.new(env)  }
    let(:env) { stub }

    describe "#new" do
      it "works" do
        runner
      end
    end

    describe "#run" do
      subject { runner.run(app) }
      let(:app) { stub }
      let(:executor) { stub  }

      before do
        env.should_receive(:session).with(executor)
        app.should_receive(:call)
        Executor.should_receive(:new).and_return(executor)
      end
      
      it "calls app" do
        subject
      end
    end
  end
end

