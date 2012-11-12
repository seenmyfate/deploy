require 'spec_helper'

module Deploy
  describe CLI do
 
    describe "#ui" do
      subject { CLI.ui }
      it "returns an instance of HighLine" do
        expect(subject).to be_a HighLine
      end
    end
  end
end
