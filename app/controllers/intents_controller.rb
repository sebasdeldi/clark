class IntentsController < ApplicationController
  def index
    @intents = Intent.all
  end
end
