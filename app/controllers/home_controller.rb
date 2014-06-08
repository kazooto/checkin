class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    @spots = Spot.all
    @hash = Gmaps4rails.build_markers(@spots) do |spot, marker|
      marker.lat spot.latitude
      marker.lng spot.longitude
      marker.infowindow spot.description
      marker.json({title: spot.name})
    end
  end
end
