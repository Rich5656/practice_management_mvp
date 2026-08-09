require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "Belongs to a firm" do
    firm = Firm.create!(name: "Test Accounting")
    client = firm.clients.create!(
      name: "Jane Smith",
      company_name: "Smith and Co",
      status: "active"
    )

    assert_equal firm, client.firm
  end

  test "Firm can have many clients" do
    firm = Firm.create!(name: "Test Accounting")
    client1 = firm.clients.create!(
      name: "Jane Smith",
      company_name: "Smith and Co",
      status: "active"
    )

    client2 = firm.clients.create!(
      name: "John Doe",
      company_name: "Doe LLC",
      status: "active"
    )

    assert_includes firm.clients, client1
    assert_includes firm.clients, client2
    assert_equal 2, firm.clients.count
  end
end
