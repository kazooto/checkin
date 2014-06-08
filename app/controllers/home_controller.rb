# -*- coding: utf-8 -*-
class HomeController < ApplicationController
  before_filter :authenticate_user!

  def about_us
  end
  
  #
  # spotの一覧表示
  #
  def index
    @spots = Spot.all
    mappable_spots = Spot.all
    #
    # google map
    #
    mappable_spots.delete_if {|spot| spot.latitude.nil? && spot.longitude.nil? }
    @hash = Gmaps4rails.build_markers(mappable_spots) do |spot, marker|
      marker.lat spot.latitude
      marker.lng spot.longitude
      marker.infowindow spot.description
      marker.json({title: spot.name})
    end
  end
end
