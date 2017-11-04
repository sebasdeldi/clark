class CommentsController < ApplicationController
  before_action :set_message
  require 'net/http'
  require 'uri'
  require 'json'


  def create
    @comment = Comment.create! content: params[:comment][:content], message: @message, user: @current_user
    uri = URI.parse("https://gateway.watsonplatform.net/conversation/api/v1/workspaces/dfdfbe3d-70c9-4600-be01-ecfcfdb337d7/message?version=2017-05-26")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth("e896f8e0-e3ef-4bab-8dd0-1caf4cafcf90", "kPhMb4vgk0Iy")
    request.content_type = "application/json"


    request.body = JSON.dump({
      "input" => {
        "text" => params[:comment][:content]
      },
      "context" => {
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
    puts "====================================================="
    puts response
    bot_answer = JSON.parse(response.body).to_h['output']['text']
    puts bot_answer
    @current_user.update(conversation_context: JSON.parse(response.body).to_h['context'])
    puts "********************************************************"
    puts JSON.parse @current_user.conversation_context
    Comment.create! content: bot_answer, message: @message, user: User.last

  end

  private
    def set_message
      @message = Message.find(params[:message_id])
    end
end