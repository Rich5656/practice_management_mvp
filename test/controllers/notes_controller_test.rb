require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  # test "should get index" do
  #   get notes_index_url
  #   assert_response :success
  # end

  test "user can view notes from a client in their firm" do 
    firm = Firm.create!(name: "Test Accounting")

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

    client.notes.create!(content: "Review of Q4 taxes.")

    sign_in_as(user)

    get client_notes_path(client)
    
    assert_response :success
    assert_includes response.body, "Review of Q4 taxes."
  end
  

  test "user cannot view notes for client of different firm" do
    firm1 = Firm.create!(name: "Test Accounting")
    firm2 = Firm.create!(name: "Other Accounting")

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

    client.notes.create!(content: "Review of Q1 taxes.")
    
    sign_in_as(user)

    get client_notes_path(client)

    assert_response :not_found
  end

  test "user can create note for client in their firm" do
    firm = Firm.create!(name: "Test Accounting")
    
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

    assert_difference "Note.count", 1 do
      post client_notes_path(client), params: {
        note: {
          content: "Review of Q1 taxes."
        }
      }
    end

    note = Note.last

    assert_equal client, note.client
    assert_equal "Review of Q1 taxes.", note.content
    assert_redirected_to client_path(client)
  end

  test "user cannot create a note for another firm that is not theirs" do 
    firm1 = Firm.create!(name: "Test Accounting")
    firm2 = Firm.create!(name: "Other Accounting")
    
    user = firm1.users.create!(
      name: "Alice",
      email_address: "alice@example.com",
      password: "password123",
      password_confirmation: "password123",
    )

    firm2_client = firm2.clients.create!(
      name: "Acme Corp",
      company_name: "Acme Corporation",
      status: "active",
    )

    sign_in_as(user)

    assert_no_difference "Note.count" do
      post client_notes_path(firm2_client), params: {
        note: {
          content: "Review of Q1 taxes."
        }
      }
    end

    assert_response :not_found
  end
end
