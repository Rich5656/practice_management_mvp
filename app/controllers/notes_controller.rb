class NotesController < ApplicationController
  before_action :set_client
  
  def index
    @notes = @client.notes.order(created_at: :desc)
  end

  def create
    @note = @client.notes.new(note_params)
    
    if @note.save
      redirect_to client_path(@client)
    else
      @notes = @client.notes.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_client
    @client = Current.user.firm.clients.find(params[:client_id])
  end 

  def note_params
    params.expect(note: [:content])
  end
end
