class MessagesController < ApplicationController
  before_action :check_user_is_auth

  def destroy
    message = Message.find(params[:id])
    message.destroy
    redirect_to :back
  end

  def show
    @message = Message.find(params[:id])
    if !@message.isread
      @message.isread=true
      @message.save
    end
  end

end
