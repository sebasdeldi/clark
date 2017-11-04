class LeadsController < ApplicationController
  layout 'leads'

  def index
    @leads = Lead.all
  end
end
