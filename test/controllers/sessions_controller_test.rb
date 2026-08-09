require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "user can view login form" do
    get new_session_path

    assert_response :success
  end

  test "user can log in with valid credentials" do
    firm = Firm.create!(name: "Test Accounting")

    user = firm.users.create!(
      name: "Alice",
      email_address: "alice@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    post session_path, params: {
      email_address: user.email_address,
      password: "password123"
    }

    assert_redirected_to root_path
  end

  test "user cannot log in with invalid credentials" do
    firm = Firm.create!(name: "Test Accounting")

    user = firm.users.create!(
      name: "Alice",
      email_address: "alice@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    post session_path, params: {
      email_address: user.email_address,
      password: "wrong-password"
    }

    assert_redirected_to new_session_path
  end
end
