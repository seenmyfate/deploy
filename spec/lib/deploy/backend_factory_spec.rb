require 'spec_helper'

module Deploy

  module Backend
    class DummyBackend
    end
  end

  describe BackendFactory do
    let(:backend_factory) { BackendFactory.new(env) }
    let(:backend) { 'DummyBackend'  }
    let(:env) { stub(backend:backend) }

    describe "#new" do
      context "with a legit backend" do
        it "takes an env" do
          expect(backend_factory)
        end
      end

      context "with a unknown backend" do
        let(:backend) { 'Unknown' }
        it "raises an error" do
          expect { backend_factory }.to raise_error 'Backend does not exist'
        end
      end
    end

    describe "#backend" do
      subject { backend_factory.backend }
      let(:dummy_backend) { stub }

      before do
        Backend::DummyBackend.should_receive(:new).with(env).
          and_return(dummy_backend)
      end

      it "returns an instance of backend" do
        expect(subject).to eq dummy_backend
      end
    end

    describe ".for" do
      subject { BackendFactory.for(env) }
      let(:backend_factory) { stub }

      before do
        BackendFactory.should_receive(:new).with(env).and_return(backend_factory)
        backend_factory.should_receive(:backend)
      end

      it "creates a new instance, calls backend" do
        subject
      end
    end
  end
end
