class Oystercard

  MAXIMUM_BALANCE = 50
  MIN_FARE = 1

  attr_reader :balance, :in_use, :entry_station, :exit_station, :journey_history

  def initialize
    @balance = 0
    @in_use = false
    @journey_history = []
  end

  def top_up_card(money)
    fail 'Maximum balance of #{maximum_balance} exceeded' if money + balance > MAXIMUM_BALANCE
    @balance += money
  end

  private def deduct_from_card(money)
    @balance -= money
  end

  def touch_in(entry_station)
    raise "Ops! Top it up!" if balance < MIN_FARE
    @entry_station = entry_station
    @in_use = true
  end

  def touch_out(exit_station)
    deduct_from_card(MIN_FARE)
    @exit_station = exit_station
    @journey_history << {:entry => @entry_station, :exit => @exit_station}
    @entry_station = nil
    @in_use = false
  end

  def in_journey?
    !!entry_station
  end

end
