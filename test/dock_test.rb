require "minitest/autorun"
require "minitest/pride"
require "./lib/dock"
require "./lib/boat"
require "./lib/renter"

class DockTest < MiniTest::Test

  def setup
    @dock = Dock.new("The Rowing Dock", 3)
    @kayak_1 = Boat.new(:kayak, 20)
    @kayak_2 = Boat.new(:kayak, 20)
    @canoe = Boat.new(:canoe, 25)
    @sup_1 = Boat.new(:standup_paddle_board, 15)
    @sup_2 = Boat.new(:standup_paddle_board, 15)
    @patrick = Renter.new("Patrick Star", "4242424242424242")
    @eugene = Renter.new("Eugene Crabs", "1313131313131313")
  end

	def test_it_exists_with_attributes
    assert_equal "The Rowing Dock", @dock.name
    assert_equal 3, @dock.max_rental_time
    assert_equal 0, @dock.revenue
	end

  def test_it_has_a_rental_log
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)

    expected = {
      @kayak_1 => @patrick,
      @kayak_2 => @patrick,
      @sup_1 => @eugene
    }

    assert_equal expected, @dock.rental_log
  end

  def test_it_can_charge_a_credit_card
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)

    @kayak_1.add_hour
    @kayak_1.add_hour

    expected = {
      :card_number => "4242424242424242",
      :amount => 40
    }

    assert_equal expected, @dock.charge(@kayak_1)
  end

  def test_it_does_not_count_hours_past_the_max_rental_time
    @dock.rent(@sup_1, @eugene)

    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    # max_rental_time == 3
    @sup_1.add_hour
    @sup_1.add_hour

    expected = {
      :card_number => "1313131313131313",
      :amount => 45
    }

    assert_equal expected, @dock.charge(@sup_1)
  end

  def test_it_can_rent_all_boats_one_more_hour
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour

    assert_equal 1, @kayak_1.hours_rented
    assert_equal 1, @kayak_2.hours_rented

    @dock.rent(@canoe, @patrick)
    @dock.log_hour

    assert_equal 2, @kayak_1.hours_rented
    assert_equal 2, @kayak_2.hours_rented
    assert_equal 1, @canoe.hours_rented

    assert_equal 0, @dock.revenue
  end

  def test_it_generates_revenue_when_boats_are_returned
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour

    @dock.rent(@canoe, @patrick)
    @dock.log_hour

    @dock.return(@kayak_1)
    @dock.return(@kayak_2)
    @dock.return(@canoe)
    assert_equal 105, @dock.revenue

    @dock.rent(@sup_1, @eugene)
    @dock.rent(@sup_2, @eugene)
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour

    @dock.log_hour
    @dock.log_hour
    @dock.return(@sup_1)
    @dock.return(@sup_2)

    assert_equal 195, @dock.revenue
  end

  def test_it_stops_logging_hours_when_boats_are_returned
    # first renter
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour

    # stop logging hours:
    @dock.return(@kayak_1) # 2 hours rented
    @dock.return(@kayak_2) # 2 hours rented
    @dock.return(@canoe) # 1 hour rented

    # second renter
    @dock.rent(@sup_1, @eugene)
    @dock.rent(@sup_2, @eugene)

    # these should not add hours to @kayak_1, @kayak_2, and @canoe
    5.times { @dock.log_hour }
    @dock.return(@sup_1) # 5 hours rented
    @dock.return(@sup_2) # 5 hours rented

    assert_equal 2, @kayak_1.hours_rented
    assert_equal 2, @kayak_2.hours_rented
    assert_equal 1, @canoe.hours_rented

    assert_equal 5, @sup_1.hours_rented
    assert_equal 5, @sup_2.hours_rented
  end

end
