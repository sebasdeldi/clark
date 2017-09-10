class MessagesController < ApplicationController
  def index
    @messages = Message.all
    respond_to do |format|
      format.html
      format.json { render(json: {messages: @messages} ) }
    end
  end

  def show
    @message = Message.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render(json: {message: @message, comments: @message.comments} ) }
    end
  end
end
