require "minitest/autorun"
require "minitest/pride"
require "./lib/renter"

class RenterTest < MiniTest::Test

	def test_it_exists_with_attributes
    renter = Renter.new("Patrick Star", "4242424242424242")
    assert_equal "Patrick Star", renter.name
    assert_equal "4242424242424242", renter.credit_card_number
	end

end
