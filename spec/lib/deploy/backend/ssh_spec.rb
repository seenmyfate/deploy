require 'spec_helper'

module Deploy
  module Backend

    describe SSH do
      let(:ssh) { SSH.new(env) }
      let(:env) { stub(user:user, roles:roles) }
      let(:user) { stub }
      let(:roles) { {app: ['10.0.0.1']} }
     
      describe "#new" do
        it "takes then env" do
          ssh
        end
      end

      describe "#session" do
        it "starts a session" do
          ssh.session.should be_a Net::SSH::Multi::Session
        end
      end

      describe "#run" do
        let(:logger) { stub }
        it "runs the command on the specified roles" do
          ssh.run(:role, 'command', logger)
        end
      end
    end
  end
end
