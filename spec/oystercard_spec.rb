require 'oystercard'

describe Oystercard do

  it 'checks balance of card is zero' do
    expect(subject.balance).to eq(0)
  end

  it 'can top up the balance' do
    expect{ subject.top_up_card 1 }.to change{ subject.balance }.by 1
  end

  it 'can deduct from the balance' do
    subject.top_up_card(10)
    expect{ subject.deduct_from_card 1 }.to change{ subject.balance }.by -1
  end

  it 'will raise an error if the maximum balance is exceeded' do
    maximum_balance = Oystercard::MAXIMUM_BALANCE
    subject.top_up_card maximum_balance
    expect{ subject.top_up_card 1 }.to raise_error 'Maximum balance of #{maximum_balance} exceeded'
  end

end
