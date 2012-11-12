require 'spec_helper'

module Deploy
  class TestMiddleware
    def initialize(app)
    end
  end

  class SystemExitMiddleware < TestMiddleware
    def call(env)
      raise SystemExit
    end
  end

  class ExceptionMiddleware < TestMiddleware
    def call(env)
      raise Exception
    end
  end


  describe Warden do
    let(:warden) { Warden.new(actions) }
    let(:actions) { [action] }
    let(:action) { [middleware, args, block] }
    let(:middleware) { stub(:middleware) }
    let(:args) { stub(:args) }
    let(:block) { Proc.new { stub(:block) } }
    let(:env) { stub }

    describe "#new" do
      before do
        middleware.should_receive(:new)
      end

      it "creates a new middleware for each action" do
        warden
      end
    end


    describe "#call" do
      context "there are actions" do
        let(:test_middleware) { stub }

        before do
          middleware.should_receive(:new).and_return(test_middleware)
          test_middleware.should_receive(:call)
        end

        it "calls the next action" do
          warden.call(env)
        end

        it "adds the action to the stack" do
          warden.call(env)
          expect(warden.stack).to eq [test_middleware]
        end
      end

      context "SystemExit called" do
        let(:action) { [SystemExitMiddleware, {}, nil] }
        it "fails" do
          expect { warden.call(env) }.to raise_error SystemExit
        end
      end

      context "Exception raised" do
        let(:action) { [ExceptionMiddleware, {}, nil] }

        before do
          warden.should_receive(:recover).with(env)
        end

        it "calls recover" do
          warden.call(env)
        end
      end
    end

    describe "#recover" do
      it "calls recover on each action in the stack" do

      end
    end

    describe "#initialize_action" do
      it "creates a new middleware for each action" do

      end
    end
  end
end
