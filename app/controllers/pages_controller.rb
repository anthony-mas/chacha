class PagesController < ApplicationController
  def home
    @events = Event.limit(5)
  end
end
