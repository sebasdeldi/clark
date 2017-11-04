class LeadsController < ApplicationController
  layout 'leads'

  def index
    @users = User.joins(:leads).uniq
    puts "======================================="
    puts @users.first.leads.inspect
    puts @users.second.leads.inspect
    puts @users.third.leads.inspect
    puts @users.fourth.leads.inspect

  end
end
