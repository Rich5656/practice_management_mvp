class DashboardController < ApplicationController
  def show
    @firm = Current.user.firm
    @clients = @firm.clients.order(created_at: :desc)
  end
end
