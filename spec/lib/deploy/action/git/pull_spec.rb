require 'spec_helper'

module Deploy
  module Git

    describe Pull do
      let(:action) { Pull.new(app, args) { block } }
      let(:app) { stub }
      let(:args) { {repo:repo} }
      let(:block) { stub }
      let(:env) { stub(session:session) }
      let(:session) { stub }
      let(:repo) { stub }

      describe "#new" do
        it "takes app, args, block" do
          action
        end
      end

      describe "#call" do

        before do
          session.should_receive(:run)
          app.should_receive(:call)
        end

        it "runs the command, calls next middleware" do
          action.call(env)
        end
      end

      describe "#recover" do
        let(:logger) { stub }

        before do
          Logger.should_receive(:new).and_return(logger)
          logger.should_receive(:info).with('recovering')
        end

        it "logs" do
          action.recover(env)
        end
      end
    end
  end
end
