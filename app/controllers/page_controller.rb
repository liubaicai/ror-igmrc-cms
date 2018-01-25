class PageController < ApplicationController

  def show
    @page = Page.where(:alias_url => params[:alias]).first
  end

end
