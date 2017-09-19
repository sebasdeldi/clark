class CommentsController < ApplicationController
  before_action :set_message
  require 'net/http'
  require 'uri'
  require 'json'


  def create
    @comment = Comment.create! content: params[:comment][:content], message: @message, user: @current_user
    uri = URI.parse("https://gateway.watsonplatform.net/conversation/api/v1/workspaces/36ce73dc-4d03-4842-957c-eb92e8ef5fbf/message?version=2017-05-26")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth("71be0b3b-ee0d-4064-b1d0-9612f8273419", "3Sk83Ixqcwvb")
    request.content_type = "application/json"
    request.body = JSON.dump({
      "input" => {
        "text" => params[:comment][:content]
      },
      "context" => {
        "conversation_id" => "1b7b67c0-90ed-45dc-8508-9488bc483d5b",
        "system" => {
          "dialog_stack" => [
            {
              "dialog_node" => "root"
            }
          ],
          "dialog_turn_counter" => 1,
          "dialog_request_counter" => 1
        }
      }
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    Comment.create! content: JSON.parse(response.body).to_h['output']['text'], message: @message, user: @current_user
  
  end

  private
    def set_message
      @message = Message.find(params[:message_id])
    end
end
