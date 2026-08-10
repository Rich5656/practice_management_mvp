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

  test "user can create a client for their firm" do
    firm = Firm.create!(name: "Test Accounting")

    user = firm.users.create!(
      name: "Alice",
      email_address: "alice@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    sign_in_as(user)

    assert_difference "Client.count", 1 do
      post clients_path, params: {
        client: {
          name: "Acme Corp",
          company_name: "Acme Corporation",
          email: "contact@acme.example",
          phone: "555-1234",
          status: "active"
        }
      }
    end

    assert_redirected_to client_path(Client.last)

    client = Client.last

    assert_equal "Acme Corp", client.name
    assert_equal "Acme Corporation", client.company_name
    assert_equal firm, client.firm
  end

  test "user cannot assign a new client to another firm" do
    firm1  = Firm.create!(name: "Test Accounting")
    firm2  = Firm.create!(name: "Other Accounting")

    user = firm1.users.create!(
      name: "Alice",
      email_address: "alice@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    
    sign_in_as(user)

    assert_difference "Client.count", 1 do
      post clients_path, params: {
         client: {
          name: "Acme Corp",
          company_name: "Acme Corporation",
          email: "contact@acme.example",
          phone: "555-1234",
          status: "active",
          firm_id: firm2.id # this intentionally tries to set the new client on a different firm, which shouldn't be allowed
        }
      }
    end

    client = Client.last

    assert_equal firm1, client.firm # the controller should have ignored the attempt to pass a firm_id
    assert_not_equal firm2, client.firm # event though I tried to force it to match firm_id for firm2 it shouldn't be able to    
  end

  test "user can see recent notes on a client page" do
    firm = Firm.create!(name: "Test Accounting")

    user = firm.users.create!(
      name: "Alice",
      email_address: "alice@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    client = firm.clients.create!(
      name: "Acme Corp",
      company_name: "Acme Corporation",
      status: "active"
    )

    client.notes.create!(content: "Review of tax documents for Q3")

    sign_in_as(user)

    get client_path(client)
    
    assert_response :success
    assert_includes response.body, "Review of tax documents for Q3"
  end 
end
