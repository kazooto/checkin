# -*- coding: utf-8 -*-
class SpotsController < ApplicationController
#  before_action :set_spot, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /spots
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
      marker.infowindow spot.name
      marker.json({title: spot.name})
    end
  end

  # GET /spots/id
  def show
    @spot = Spot.where(:id => params[:id]).first
  end

  # GET /spots/new
  def new
    @spot = Spot.new
    @spot.attributes = spot_params if request.post?
  end

  # GET /spots/1/edit
  def edit
    @spot = Spot.where(:id => params[:id]).first
    @spot.attributes = spot_params if request.patch?
    check_authenticated_user
  end

  # POST /spots
  def confirm
    if request.post?
      @spot = Spot.new(spot_params)
    else
      @spot = Spot.where(:id => params[:id]).first
      @spot.attributes = spot_params
    end
    if @spot.valid?
      render :action => 'confirm'
    else
      render :action => request.post? ? 'new' : 'edit'
    end
  end
  
  # POST /spots
  def create
    @spot = Spot.new(spot_params)
    @spot.user_id = current_user.id

    begin
      Spot.transaction do
        respond_to do |format|
          if @spot.save!
            format.html { redirect_to spots_path, notice: "#{@spot.name}の新規登録が完了しました！" }
          else
            format.html { render action: 'new' }
          end
        end
      end
    rescue Exception => e
      flash[:errors] = "エラーが発生しました！"
      redirect_to spots_path
    end
  end

  # PATCH/PUT /spots/1
  def update
    @spot = Spot.where(:id => params[:id]).first
    check_authenticated_user
    respond_to do |format|
      if @spot.update(spot_params)
        format.html { redirect_to spots_path, notice: "#{@spot.name}の更新が完了しました！" }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /spots/1
  def destroy
    @spot = Spot.where(:id => params[:id]).first
    check_authenticated_user
    @spot.destroy
    respond_to do |format|
      format.html { redirect_to spots_url, notice: "#{@spot.name}を削除しました！"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spot
      @spot = Spot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spot_params
      params.require(:spot).permit(:name, :category_id, :description, :address, :tel, :url, :latitude, :longitude)
    end

    # 権限を持ったユーザかどうかを判定
    def check_authenticated_user
      unless @spot.user_id == current_user.id
        respond_to do |format|
          format.html {redirect_to spots_path, alert: "#{@spot.name}の編集はできません！"}
        end
        return
      end
    end
end
