class LeadsController < ApplicationController
  layout 'leads'

  def index
    @users = User.joins(:leads).uniq
  end
end
