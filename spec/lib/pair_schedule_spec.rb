require 'pair/schedule'
require 'fileutils'

describe Pair::Schedule do
  let(:instance) { described_class.new(schedule_file) }
  let(:temp_dir) { 'tmp'}
  let(:schedule_file) { File.join(temp_dir,'tmp_pairing_schedule.yml') }

  before do
    FileUtils.mkdir_p(temp_dir)
    File.open(schedule_file, 'w')
  end

  after(:each) do
    File.delete(schedule_file) if File.exists?(schedule_file)
  end

  describe "#days_since" do
    subject { instance.days_since(pair)}
    let(:pair) { [:ab,:cd] }
    let(:other_pair) { [:ef, :gh]}
    let(:today) { Date.today }
    let(:previous_day) { today - days}
    let(:days) { rand(1..10) }
    let(:data) { {} }

    before do
      instance.write(data)
    end

    shared_examples_for "returns nil" do
      specify do
        subject.should be_nil
      end
    end

    shared_examples_for "returns the days since most recent pairing" do
      specify do
        subject.should == days
      end
    end

    context "pair matches a previous day" do
      let(:data) { { previous_day => [ pair, other_pair ] }}
      it_behaves_like "returns the days since most recent pairing"

      context "soloing" do
        let(:pair) { [:ab] }
        it_behaves_like "returns the days since most recent pairing"
      end

      context "pair in different order" do
        let(:data) { { previous_day => [ [:cd,:ab], other_pair ] }}
        it_behaves_like "returns the days since most recent pairing"
      end

      context "pair matches multiple days" do
        let(:data) do
          { previous_day => [ pair, other_pair ],
            previous_day - 1 =>  [ pair, other_pair ]
          }
        end
        it_behaves_like "returns the days since most recent pairing"
      end
    end

    context "no previous data exists" do
      it_behaves_like "returns nil"
    end

    context "pair does not match previous data" do
      let(:data) { { previous_day => [ other_pair ] }}
      it_behaves_like "returns nil"
    end

    context "pair matches today" do
      let(:data) { { today => [ pair ] }}
      it_behaves_like "returns nil"
    end

  end

end