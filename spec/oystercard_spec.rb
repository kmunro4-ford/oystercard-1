require 'oystercard'

describe Oystercard do

  it 'checks balance of card is zero' do
    expect(subject.balance).to eq(0)
  end

  it 'can top up the balance' do
    expect{ subject.top_up_card 1 }.to change{ subject.balance }.by 1
  end

end
