require 'spec_helper'

module Deploy
  describe Executor do
    let(:executor) { Executor.new(env)}
    let(:env) { stub }
    let(:backend) { stub }

    before do
      BackendFactory.should_receive(:for).with(env).and_return(backend)
    end

    describe "#new" do
      subject { executor }

      it "takes an env, returns an executor" do
        expect(subject).to be_a Executor
      end
    end

    describe "#run" do
      subject { executor.run(role, command, logger) }
      let(:role) { stub }
      let(:command) { stub }
      let(:logger) { stub }

      before do
        backend.should_receive(:run).with(role, command, logger)
      end

      it "delegates to the backend" do
        subject
      end
    end
  end
end
