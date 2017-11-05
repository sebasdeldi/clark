class CommentsController < ApplicationController
  before_action :set_message
  require 'net/http'
  require 'uri'
  require 'json'


  def create
    @comment = Comment.create! content: params[:comment][:content], message: @message, user: @current_user
    uri = URI.parse("https://gateway.watsonplatform.net/conversation/api/v1/workspaces/06ffe33b-9075-411e-9b92-01ccdbe24b1f/message?version=2017-05-26")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth("e896f8e0-e3ef-4bab-8dd0-1caf4cafcf90", "kPhMb4vgk0Iy")
    request.content_type = "application/json"
    context = @current_user.conversation_context.nil? ? {} : JSON.parse(@current_user.conversation_context.to_s.gsub! "=>", ":")

    request.body = JSON.dump({
      "input": {
        "text": params[:comment][:content]
      },
      "context": context
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    entity = JSON.parse(response.body)["entities"].first.nil? ? "" : JSON.parse(response.body)["entities"].first["value"]
    context = ((JSON.parse response.body)["context"])
    bot_answer = JSON.parse(response.body).to_h['output']['text']

    puts "==============================================="
    puts JSON.parse(response.body)["entities"]



    if entity == "telefono"
      @current_user.update(phone: entity)
    elsif entity == "email"
      @current_user.update(email: entity)
    elsif entity != ""
      Lead.create(user: @current_user, subject: entity)
    end

    @current_user.update(conversation_context: context)
    Comment.create! content: bot_answer.first , message: @message, user: User.last
  end

  private
    def set_message
      @message = Message.find(params[:message_id])
    end
end