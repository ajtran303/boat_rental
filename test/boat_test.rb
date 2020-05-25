require "minitest/autorun"
require "minitest/pride"
require "./lib/boat"

class BoatTest < MiniTest::Test

  def setup
    @kayak = Boat.new(:kayak, 20)
  end

	def test_it_exists_with_attributes
    assert_instance_of Boat, @kayak
    assert_equal :kayak, @kayak.type
    assert_equal 20, @kayak.price_per_hour
    assert_equal 0, @kayak.hours_rented
	end

  def test_it_can_be_rented_by_hour
    assert_equal 0, @kayak.hours_rented
    @kayak.add_hour
    @kayak.add_hour
    @kayak.add_hour
    assert_equal 3, @kayak.hours_rented
  end

  def test_it_can_get_rented_and_returned
    assert_equal false, @kayak.is_rented?
    @kayak.rent
    assert_equal true, @kayak.is_rented?
    @kayak.return
    assert_equal false, @kayak.is_rented?
  end

end
