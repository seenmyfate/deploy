require 'spec_helper'

module Deploy
  module Bundle

    describe Install do
      let(:install) { Install.new(app, args) { block } }
      let(:app) { stub }
      let(:args) { stub }
      let(:block) { stub }
      let(:env) { stub(session:session) }
      let(:session) { stub }

      describe "#new" do
        it "takes app, args, block" do
          install
        end
      end

      describe "#call" do

        before do
          session.should_receive(:run)
          app.should_receive(:call)
        end

        it "runs the bundle command, calls next middleware" do
          install.call(env)
        end
      end

      describe "#recover" do
        let(:logger) { stub }

        before do
          Logger.should_receive(:new).and_return(logger)
          logger.should_receive(:info).with('recovering')
        end

        it "logs" do
          install.recover(env)
        end
      end
    end
  end
end

