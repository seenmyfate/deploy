require 'spec_helper'

module Deploy
  describe Env do

    describe "api" do
      it "works for the example" do
        sandbox = Deploy::Env.new(:sandbox) do |env|
          env.role :app, %w{example.com}
          env.role :web, %w{example.com}
          env.role :db, %w{example.com}
          env.user 'tomc'
          env.path '/var/www/my_app/current'
          env.backend 'SSH'
        end

        expect(sandbox.roles).to eq({
          app: %w{example.com},
          web: %w{example.com},
          db: %w{example.com},
        })
        expect(sandbox.user).to eq 'tomc'
        expect(sandbox.path).to eq '/var/www/my_app/current'
        expect(sandbox.backend).to eq 'SSH'
      end
    end


    let(:name) { :test }
    let(:env) { Env.new(name)  }
    describe "#new" do
      it "takes a name" do
        env
      end
    end

    describe "#role" do
      it "adds a role" do
        env.role(:app, %w{example.com})
        expect(env.roles).to eq({app: %w{example.com}})
      end
    end

    describe "#respond_to?" do
      context "key is set" do
        it "returns true" do
          env.this_is_a_test true
          expect(env.respond_to?(:this_is_a_test)).to be_true
        end
      end

      context "key is not set" do
        it "returns false" do
          expect(env.respond_to?(:this_is_a_test)).to be_false
        end
      end

    end
  end
end
