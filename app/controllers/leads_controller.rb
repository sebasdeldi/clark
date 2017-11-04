class LeadsController < ApplicationController
  layout 'leads'

  def index
    @users = User.joins(:leads)
    puts "======================================="
    puts @users
  end
end
