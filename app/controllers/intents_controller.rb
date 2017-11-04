class IntentsController < ApplicationController
  def index
    @leads = Lead.all
  end
end
