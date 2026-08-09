require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated user is redirected" do
    get root_path

    assert_response :redirect
  end

  test "authenticated user can view their dashboard" do
    firm = Firm.create!(name: "Test Accounting")

    user = firm.users.create!(
      name: "Alice",
      email_address: "alice@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    sign_in_as(user)

    get root_path

    assert_response :success
    assert_includes response.body, "Test Accounting"
    assert_includes response.body, "Alice"
  end
end
