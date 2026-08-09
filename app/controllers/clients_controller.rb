class ClientsController < ApplicationController
  def index
    @clients = Current.user.firm.clients.order(name: :asc)
  end

  def show
    @client = Current.user.firm.clients.find(params[:id])
  end

  def new
    @client = Current.user.firm.clients.new
  end

  def create
    @client = Current.user.firm.clients.new(client_params)
    
    if @client.save
      redirect_to @client
    else
      render :new, status: :unprocessable_entitiy
    end
  end

  def edit
    @client = Current.user.firm.clients.find(params[:id])
  end 

  def update
    @client = Current.user.firm.clients.find(params[:id])
    
    if @client.update(client_params)
      redirect_to @client
    else
      render :edit, status: :unprocessable_entitiy
    end
  end 

  def destroy
    @client = Current.user.firm.clients.find(params[:id])
    @client.destroy

    redirect_to clients_path
  end

  private

  def client_params
    params.expect(
      client: [:name, :company_name, :email, :phone, :status]
    )
  end

end
