class Dock

  attr_reader :name,
              :max_rental_time,
              :rental_log,
              :revenue

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = {}
    @revenue = 0
  end

  def rent(boat, renter)
    boat.rent
    rental_log[boat] = renter
  end

  def charge(boat)
    card_to_charge = @rental_log[boat].credit_card_number
    hours = boat.hours_rented
    hours_to_charge = nil

    if hours > @max_rental_time
      hours_to_charge = @max_rental_time
    else
      hours_to_charge = hours
    end

    price = hours_to_charge * boat.price_per_hour

    {
      :card_number => card_to_charge,
      :amount => price
    }
  end

  def log_hour
    boats = @rental_log.keys
    boats.each do |boat|
      boat.add_hour if boat.is_rented?
    end
  end

  def return(boat)
    @revenue += charge(boat)[:amount]
    boat.return
  end

end
