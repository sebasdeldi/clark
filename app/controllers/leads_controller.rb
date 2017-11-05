class LeadsController < ApplicationController
  layout 'leads'

  def index
    @users = User.joins(:leads).uniq
    puts "======================================="
    puts User.all
    puts User.all.count
    puts User.all.inspect
    puts User.last.inspect

  end
end
