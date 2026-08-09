require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
  test "user can view a client belonging to their firm" do
    firm  = Firm.create!(name: "Test Accounting")

    user = firm.users.create!(
      name: "Alice",
      email_address: "alice@example.com",
      password: "password123",
      password_confirmation: "password123",
    )

    client = firm.clients.create!(
      name: "Acme Corp",
      company_name: "Acme Corporation",
      status: "active",
    )

    sign_in_as(user)

    get client_path(client)

    assert_response :success
    assert_includes response.body, "Acme Corp"
  end

  test "user cannot view a client belonging to another firm" do
    firm1 = Firm.create!(name: "Test Accounting One")
    firm2 = Firm.create!(name: "Test Accounting Two")
    
    user = firm1.users.create!(
      name: "Alice",
      email_address: "alice@example.com",
      password: "password123",
      password_confirmation: "password123",
    )

    client = firm2.clients.create!(
      name: "Acme Corp",
      company_name: "Acme Corporation",
      status: "active",
    )

    sign_in_as(user)

    
    get client_path(client)
    assert_response :not_found
  end
end
