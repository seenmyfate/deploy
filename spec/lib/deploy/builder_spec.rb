require 'spec_helper'

module Deploy
  describe Builder do
    let(:builder) { Builder.new  }

    describe "api" do
      it "works for the example" do
        deploy = Deploy::Builder.new do |b|
          b.use Deploy::Git::Pull, repo: 'git@git.onthebeach.co.uk:onthebeach/my_app.git'
          b.use Deploy::Bundle::Install
          b.use Deploy::Rake::Migrate
          b.use Deploy::Unicorn::Restart
          b.use Deploy::Notification::Twitter
        end
        expect(deploy.stack).to eq [[Deploy::Git::Pull, [{:repo=>"git@git.onthebeach.co.uk:onthebeach/my_app.git"}], nil], [Deploy::Bundle::Install, [], nil], [Deploy::Rake::Migrate, [], nil], [Deploy::Unicorn::Restart, [], nil], [Deploy::Notification::Twitter, [], nil]] 
      end
      
      it "works for nested" do
        prep = Deploy::Builder.new do |b|
          b.use Deploy::Git::Pull, repo: 'git@git.onthebeach.co.uk:onthebeach/my_app.git'
          b.use Deploy::Bundle::Install
          b.use Deploy::Rake::Migrate
        end
        restart = Deploy::Builder.new do |b|
          b.use Deploy::Unicorn::Restart
        end
        deploy = Deploy::Builder.new do |b|
          b.use prep
          b.use restart
          b.use Deploy::Notification::Twitter
        end
        expect(deploy.stack).to eq [[Deploy::Git::Pull, [{:repo=>"git@git.onthebeach.co.uk:onthebeach/my_app.git"}], nil], [Deploy::Bundle::Install, [], nil], [Deploy::Rake::Migrate, [], nil], [Deploy::Unicorn::Restart, [], nil], [Deploy::Notification::Twitter, [], nil]] 
      end
 
    end

    describe "#stack" do
      subject { builder.stack }

      context "#new" do
        it "initializes with an empty stack" do
          expect(subject).to be_empty
        end
      end

      context "#use" do
        subject { builder.stack }

        before do
          builder.use('middleware', 'args') { 'block' }
        end

        it "adds the middleware to the stack" do
          expect(subject.count).to eq 1
        end
      end
    end

    describe "#call" do
      let(:env) { stub }
      let(:warden) { stub }
      let(:stack) { stub }

      before do
        builder.should_receive(:to_app).and_return(warden)
        warden.should_receive(:call).with(env)
      end

      it "calls the app" do
        builder.call(env)
      end
    end

    describe "#to_app" do
      subject { builder.to_app }
      let(:warden) { stub }
      let(:stack) { stub }

      before do
        builder.stack.should_receive(:dup).and_return(stack)
        Warden.should_receive(:new).with(stack).and_return(warden)
      end

      it "creates a new Warden" do
        expect(subject).to eq warden
      end
    end
  end
end

