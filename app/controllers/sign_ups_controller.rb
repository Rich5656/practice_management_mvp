class SignUpsController < ApplicationController
  allow_unauthenticated_access
  def new
    @user = User.new
    @firm = Firm.new
  end

  def create
    @firm = Firm.new(firm_params)
    @user = @firm.users.build(user_params)

    if @firm.save
      start_new_session_for(@user)
      redirect_to root_path
    else
      render :new, status: :unprocessable_entitiy
    end
  end


  private

  def firm_params
    params.expect(firm: [:name])
  end

  def user_params
    params.expect(user: [:name, :email_address, :password, :password_confirmation])
  end 

end
