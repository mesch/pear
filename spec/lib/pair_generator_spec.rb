require 'pair/generator'

describe Pair::Generator do
  let(:developers) { [1,2,3,4,5,6] }
  let(:required) { [] }

  let(:instance) { described_class.new(developers.dup)}

  describe "#random" do
    subject { instance.random(required) }

    shared_examples_for "includes all developers" do
      specify do
        subject.flatten.to_set.should == developers.to_set
      end
    end

    it "puts developers in pairs" do
      subject.should == [[anything(),anything()],[anything(),anything()],[anything(),anything()]]
    end

    it_behaves_like "includes all developers"

    context "required pairs are set" do

      context "fixed required pairs" do
        let(:required) { [[4,5], [6]] }

        it "keeps the required pairs" do
          subject.should == [[4,5],[6],[anything(),anything()],[anything()]]
        end
        it_behaves_like "includes all developers"
      end

      context "variable required pairs" do
        let(:required) { [[5,:any],[6]] }

        it "keeps the required pairs, replacing :any with any developer" do
          subject.should == [[5,anything()],[6],[anything(),anything()],[anything()]]
        end
        it_behaves_like "includes all developers"
      end

    end

  end

end