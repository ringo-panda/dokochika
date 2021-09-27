class Public::SpotsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  require 'httpclient'

  def new
    @place_id = params[:format]
    url = "https://maps.googleapis.com/maps/api/place/details/json?parameters"
    query = {
      key:ENV['GOOGLE_MAP_API'],
      place_id:@place_id,
      language: "ja"
    }
    client = HTTPClient.new
    response = client.get(url, query: query)
    @result = JSON.parse(response.body, {symbolize_names: true})
    if @result[:status] != "OK"
      flash[:alert] = @result[:error_message]
    end
    @spot = Spot.new
  end

  def index
    @spots = Spot.where(user_id:current_user.id)
  end

  def create
    @spots = Spot.where(user_id:current_user.id)
    @spot = Spot.new(spot_params)
    lists = params[:spot][:lists]
    if @spot.save
      lists.each do |list_id|
        if list_id.present?
          join = ListSpot.new(user_id:current_user.id, spot_id:@spot.id, list_id:list_id.to_i)
          unless join.save
            flash[:notice] = "保存に失敗しました"
            redirect_to spots_path
          end
        end
      end
      flash[:notice] = "保存に成功しました"
      redirect_to spots_path
    else
      flash[:notice] = "保存に失敗しました"
      render "index"
    end
  end

  def edit
    @spot = Spot.find(params[:id])
    @lists = @spot.lists.pluck(:id)
  end

  def update
    @spot = Spot.find(params[:id])
    new_lists = params[:spot][:lists]
    if new_lists.blank?
      if @spot.destroy
        flash[:notice] = "削除に成功しました"
      end
    else
      new_lists.map(&:to_i)
      old_lists = @spot.lists.pluck(:id)
      delete_lists = old_lists - new_lists
      create_lists = new_lists - old_lists
      if @spot.update(spot_params)
        if delete_lists.present?
          delete_lists.each do |list_id|
            join = ListSpot.find_by(user_id:current_user, spot_id:@spot.id, list_id:list_id)
            if join.present?
              join.destroy
            end
          end
        end
        if create_lists.present?
          create_lists.each do |list_id|
            join = ListSpot.new(user_id:current_user, spot_id:@spot.id, list_id:list_id)
            join.save
          end
        end
        flash[:notice] = "保存に成功しました"
      else
        flash[:notice] = "保存に失敗しました"
      end
    end
    redirect_to spots_path
  end


  def search
    url = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
    query = {
      key:ENV['GOOGLE_MAP_API'],
      query:params[:search_keyword],
      language: "ja"
    }
    client = HTTPClient.new
    response = client.get(url, query: query)
    @result_spots = JSON.parse(response.body, {symbolize_names: true})
    if @result_spots[:status] != "OK"
      flash[:alert] = @result_spots[:error_message]
    end
    render 'index'

  end

  private
  def spot_params
    params.require(:spot).permit(:formatted_address, :name, :place_id, :lat, :lng).merge(user_id: current_user.id)
  end

  def correct_user
    @spot = Spot.find(params[:id])
    if @spot.user.id != current_user.id
      flash[:alert] = "このURLは無効です"
      redirect_to root_path
    end
  end

end
