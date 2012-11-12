require 'spec_helper'

module Deploy
  module Notification

    describe Twitter do
      let(:action) { Twitter.new(app, args) { block } }
      let(:app) { stub }
      let(:args) { stub }
      let(:block) { stub }
      let(:env) { stub(session:session) }
      let(:session) { stub }

      describe "#new" do
        it "takes app, args, block" do
          action
        end
      end

      describe "#call" do

        before do
          action.should_receive(:tweet)
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
