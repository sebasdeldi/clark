class LeadsController < ApplicationController
  layout 'leads'

  def index
    @users = User.joins(:leads)
    puts "======================================="
    puts @users.first.leads
    puts @users.second.leads
    puts @users.third.leads
    puts @users.fourth.leads

  end
end
