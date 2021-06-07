class Oystercard

  MAXIMUM_BALANCE = 50

  attr_reader :balance

  def initialize
    @balance = 0
  end

  def top_up_card(money)
    fail 'Maximum balance of #{maximum_balance} exceeded' if money + balance > MAXIMUM_BALANCE
    @balance += money
  end

  def deduct_from_card(money)
    @balance -= money
  end
  
end
