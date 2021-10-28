class Public::DirectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:calculate]

  def calculate
    #リクエスト用のクエリパラメータの作成
    parameter = {places:"", avoid:"", origin:"", departure_datetime:""}
    @param = params
    @list = List.find(params[:list_id])
    @spots = @list.spots
    if params[:lat].present? && params[:lng].present?
      parameter[:origin] = params[:lat] + "," + params[:lng]
    else
      flash[:alert] = "出発地の情報が指定されていません。"
      redirect_to list_path(@list) and return
    end
    url = "https://maps.googleapis.com/maps/api/directions/json?"
    query = {
      key:ENV['GOOGLE_MAP_API'],
      origin:parameter[:origin],
      language: "ja",
      destination:""
    }
    avoids=[]
    if params[:avoid_tolls] == "1"
      avoids.push("tolls")
    end
    if params[:avoid_highways] == "1"
      avoids.push("highways")
    end
    if params[:avoid_ferries] == "1"
      avoids.push("ferries")
    end
    if avoids.present?
      parameter[:avoid] = avoids.join("|")
      query.store(:avoid, parameter[:avoid])
    end
    if params[:departure_datetime].present?
      departure_datetime = Time.parse(params[:departure_datetime])
      if departure_datetime >= Time.now
        parameter[:departure_datetime] = departure_datetime.to_i
        query.store(:departure_time, parameter[:departure_datetime])
      else
        flash[:alert] = "現在より前の日時は指定できません"
        redirect_to list_path(@list) and return
      end
    end
    #順に車、自転車、徒歩それぞれ順に繰り返しでhttpリクエストをし、結果を配列に格納
    @driving_results = []
    @walking_results = []
    @bicycling_results = []
    @modes = ["bicycling", "walking", "driving"]
    count = 0
    @modes.each do |mode|
      query.store(:mode, mode)
      @spots.each do |spot|
        query.store(:destination, "place_id:" + spot.place_id)
        client = HTTPClient.new
        response = client.get(url, query: query)
        result = JSON.parse(response.body, {symbolize_names: true})
        if result[:status] != "OK"
          count += 1
          flash[:alert] = "#{count}件のルート検索でエラーが発生しました。"
        else
          if mode == "driving"
            @driving_results.push(result)
          elsif mode == "walking"
            @walking_results.push(result)
          elsif mode == "bicycling"
            @bicycling_results.push(result)
          end
        end
      end
    end
    #検索結果をソートする
    @driving_results_sort = @driving_results.sort_by {|a| a[:routes][0][:legs][0][:duration][:value].to_i }
    @walking_results_sort = @walking_results.sort_by {|a| a[:routes][0][:legs][0][:duration][:value].to_i }
    @bicycling_results_sort = @bicycling_results.sort_by {|a| a[:routes][0][:legs][0][:duration][:value].to_i }
  end


  private

  def correct_user
    @list = List.find(params[:list_id])
    if @list.user.id != current_user.id
      flash[:alert] = "このURLは無効です"
      redirect_to root_path
    end
  end

end
