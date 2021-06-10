require 'oystercard'

describe Oystercard do

  describe "#top_up_card" do

    it 'checks balance of card is zero' do
      expect(subject.balance).to eq(0)
    end

    it 'can top up the balance' do
      expect{ subject.top_up_card 1 }.to change{ subject.balance }.by 1
    end

    it 'will raise an error if the maximum balance is exceeded' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up_card maximum_balance
      expect{ subject.top_up_card 1 }.to raise_error 'Maximum balance of #{maximum_balance} exceeded'
    end
  end

  describe "#deduct_from_card" do
    let(:exit_station){ double :station }
    it 'can deduct from the balance' do
      subject.top_up_card(10)
      expect{ subject.touch_out(exit_station) }.to change{ subject.balance }.by -1
    end
  end

  describe "#touch_in" do
    let(:entry_station){ double :station }
    it { is_expected.to respond_to(:touch_in) }
    it "touches in" do
      allow(subject).to receive(:balance).and_return 10
      expect(subject.touch_in(entry_station)).to eq(true)
    end
    it "raises an error if card under £1" do
      allow(subject).to receive(:balance).and_return 0.5
      expect{subject.touch_in(entry_station)}.to raise_error "Ops! Top it up!"
    end
    it "stores the entry station" do
      subject.top_up_card(10)
      subject.touch_in(entry_station)
      expect( subject.entry_station ).to eq(entry_station)
    end
  end

  describe "#touch_out" do
    let(:entry_station){ double :station }
    let(:exit_station){ double :station }
    it "touches out" do
      allow(subject).to receive(:balance).and_return 10
      expect(subject.touch_out(exit_station)).to eq(false)
    end

    it "saves current journey history" do
      expect(subject.journey_history).to be_instance_of(Array)
    end

    it "stores at touch out the current journey history" do
      subject.top_up_card(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journey_history).to eq([{:entry => entry_station, :exit => exit_station}])
    end

    it "stores the exit station" do
      subject.top_up_card(10)
      subject.touch_out(exit_station)
      expect( subject.exit_station ).to eq(exit_station)
    end

    it "forgets the entry station" do
      subject.top_up_card(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.entry_station).to eq(nil)
    end

    it "check if in journey" do
      allow(subject).to receive(:balance).and_return 10
      subject.touch_in(entry_station)
      expect(subject).to be_in_journey
    end

    it "check if not in journey" do
      allow(subject).to receive(:balance).and_return 10
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject).not_to be_in_journey
    end

    it "charges the card when you touch out" do
      expect{ subject.touch_out(exit_station) }.to change(subject, :balance).by(-1)
    end

    it "stores at touch out the current journey history" do
      subject.top_up_card(10)
      subject.touch_in("Kings Cross")
      subject.touch_out("Victoria")
      expect(subject.journey_history).to eq([{:entry => "Kings Cross", :exit => "Victoria"}])
    end

  end

end
