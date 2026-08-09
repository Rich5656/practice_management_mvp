require "test_helper"

class SignUpsControllerTest < ActionDispatch::IntegrationTest
  test "user can view signup form" do
    get sign_up_path

    assert_response :success
  end

  test "user can sign up and is redirected to dashboard" do
    assert_difference "Firm.count", 1 do
      assert_difference "User.count", 1 do
        post sign_up_path, params: {
          firm: {
            name: "Test Accounting"
          },
          user: {
            name: "Alice",
            email_address: "alice@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        }
      end
    end

    assert_redirected_to root_path

    user = User.find_by!(email_address: "alice@example.com")

    assert_equal "Alice", user.name
    assert_equal "Test Accounting", user.firm.name
  end
end
