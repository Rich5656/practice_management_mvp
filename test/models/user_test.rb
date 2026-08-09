require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "belongs to a firm" do
    firm = Firm.create!(name: "Test Accounting")

    user = firm.users.create!(
      name: "Jane Smith",
      email_address: "jane@example.com",
      password: "password123",
      password_confirmation: "password123",
    )

    assert_equal firm, user.firm
  end
end
