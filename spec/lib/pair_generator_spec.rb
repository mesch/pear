require 'pair/generator'

describe Pair::Generator do
  let(:instance) { described_class.new(developers) }

  shared_examples_for "returns expected" do
    specify do
      subject.should == expected
    end
  end

  describe "#combinations" do
    subject { instance.combinations }

    context "0 developers" do
      let(:developers) { [] }
      let(:expected) { [[]] }
      it_behaves_like "returns expected"
    end

    context "1 developer" do
      let(:developers) { [:a] }
      let(:expected) { [[[:a]]] }
      it_behaves_like "returns expected"
    end

    context "2 developers" do
      let(:developers) { [:a, :b] }
      let(:expected) { [[[:a, :b]]] }
      it_behaves_like "returns expected"
    end

    context "3 developers" do
      let(:developers) { [:a, :b, :c] }
      let(:expected) { [
          [[:a], [:b, :c]],
          [[:a, :b], [:c]],
          [[:a, :c], [:b]]
      ] }
      it_behaves_like "returns expected"
    end

    context "required pairs are set" do
      let(:instance) { described_class.new(developers, required) }

      context "fixed required pairs" do
        let(:developers) { [:a, :b, :c, :d, :e, :f] }
        let(:required) { [[[:d, :e], [:f]]] }
        let(:expected) { [
            [[:d,:e],[:f], [:a], [:b, :c]],
            [[:d,:e],[:f], [:a, :b], [:c]],
            [[:d,:e],[:f], [:a, :c], [:b]]
        ] }

        it_behaves_like "returns expected"
      end
    end

    context "required anchors are set" do
      let(:instance) { described_class.new(developers, [[]], anchors) }
      let(:required) { [[]] }

      context "one anchor" do
        let(:developers) { [:a, :b, :c] }
        let(:anchors) { [:a] }
        let(:expected) { [
            [[:a, :b], [:c]],
            [[:a, :c], [:b]]
        ] }
        it_behaves_like "returns expected"
      end

      context "two anchors" do
        let(:developers) { [:a, :b, :c, :d] }
        let(:anchors) { [:a, :b] }
        let(:expected) { [
            [[:a, :c], [:b, :d]],
            [[:a, :d], [:b, :c]]
        ] }
        it_behaves_like "returns expected"
      end
    end

  end
end