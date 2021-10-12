module ApplicationHelper
  def place_photo(photo_key)
    return "https://maps.googleapis.com/maps/api/place/photo?photo_reference=#{photo_key}&maxwidth=1000&key=#{ENV['GOOGLE_MAP_API']}"
  end

  def make_dir_url(param, place_id, mode, location)
    origin = "origin=" + param[:lat] + "%2C" + param[:lng]
    destination = "destination=" + location[:lat].to_s + "%2C" + location[:lng].to_s
    destination_place_id = "destination_place_id=" + place_id
    travelmode = "travelmode=" + mode
    url = "https://www.google.com/maps/dir/?api=1&" + origin + "&" + destination + "&" + destination_place_id + "&" + travelmode
    return url
  end

  def calc_arrival_time(departure_time, value)
    arrival_time_serial_num = departure_time + value
    arrival_time = Time.zone.at(arrival_time_serial_num).strftime('%m/%d %H時%M分着')
    return arrival_time
  end

  def judge_present_place(place_id)
    @spot = Spot.find_by(user_id:current_user.id, place_id:place_id)
    if @spot.present?
      return @spot
    else
      return nil
    end
  end

  def pick_up_url(a_tag)
    @photographing_person = {url:a_tag, name:a_tag}
    @photographing_person[:url] = @photographing_person[:url].slice(@photographing_person[:url].index("=")+2,@photographing_person[:url].index(">")-(@photographing_person[:url].index("=")+3))
    @photographing_person[:name] = @photographing_person[:name].slice(@photographing_person[:name].index(">")+1,@photographing_person[:name].rindex("<")-(@photographing_person[:name].index(">")+1))
    return @photographing_person
  end

  def place_details(place_id)
    url = "https://maps.googleapis.com/maps/api/place/details/json?parameters"
    query = {
      key:ENV['GOOGLE_MAP_API'],
      place_id:place_id,
      language: "ja"
    }
    client = HTTPClient.new
    response = client.get(url, query: query)
    @result = JSON.parse(response.body, {symbolize_names: true})
    return @result
  end

  def judge_place_open(result)
    @place_opening_status = {status:"", color:"red", time:""}
    if result[:result][:business_status] == "CLOSED_PERMANENTLY"
      @place_opening_status[:status] = "閉業"
    elsif result[:result][:business_status] == "CLOSED_TEMPORARILY"
      @place_opening_status[:status] = "臨時休業"
    else
      if result[:result][:opening_hours].present?
        if result[:result][:opening_hours][:open_now]
          @place_opening_status[:status] = "営業中"
          @place_opening_status[:color] = "green"
          if Date.today.wday == 0
            @place_opening_status[:time] = result[:result][:opening_hours][:weekday_text][6]
          else
            @place_opening_status[:time] = result[:result][:opening_hours][:weekday_text][Date.today.wday-1]
          end
        else
          @place_opening_status[:status] = "営業時間外"
          if Date.today.wday == 0
            @place_opening_status[:time] = result[:result][:opening_hours][:weekday_text][6]
          else
            @place_opening_status[:time] = result[:result][:opening_hours][:weekday_text][Date.today.wday-1]
          end
        end
      else
        @place_opening_status[:status] = "営業時間を取得できませんでした。"
      end
    end
    return @place_opening_status
  end

  def translate_place_types(en_types)
    @translate_ja_en_types = {
      "accounting"=>"会計事務所",
      "airport"=>"空港",
      "amusement_park"=>"遊園地",
      "aquarium"=>"水族館",
      "art_gallery"=>"美術館",
      "atm"=>"ATM",
      "bakery"=>"パン屋",
      "bank"=>"銀行",
      "bar"=>"バー",
      "beauty_salon"=>"美容室",
      "bicycle_store"=>"自転車屋",
      "book_store"=>"書店",
      "bowling_alley"=>"ボウリング場",
      "bus_station"=>"バス停",
      "cafe"=>"カフェ",
      "campground"=>"キャンプ場",
      "car_dealer"=>"自動車ディーラー",
      "car_rental"=>"レンタカー屋",
      "car_repair"=>"	自動車修理、板金屋",
      "car_wash"=>"洗車場",
      "casino"=>"カジノ",
      "cemetery"=>"墓地",
      "church"=>"教会",
      "city_hall"=>"市役所",
      "clothing_store"=>"洋服店",
      "convenience_store"=>"コンビニ",
      "courthouse"=>"裁判所",
      "dentist"=>"歯科",
      "department_store"=>"デパート",
      "doctor"=>"医者",
      "electrician"=>"電気事業者",
      "electronics_store"=>"電気屋",
      "embassy"=>"大使館",
      "establishment"=>" ",
      "finance"=>"財務機関",
      "fire_station"=>"消防署",
      "florist"=>"花屋",
      "food"=>"飲食店",
      "funeral_home"=>"斎場",
      "furniture_store"=>"家具屋",
      "gas_station"=>"ガソリンスタンド",
      "general_contractor"=>"ゼネコン",
      "grocery_or_supermarket"=>"	日用品店、スーパーマーケット",
      "gym"=>"ジム",
      "hair_care"=>"床屋",
      "hardware_store"=>"工具店、ホームセンター",
      "health"=>"医療機関",
      "hindu_temple"=>"ヒンドゥー寺院",
      "home_goods_store"=>"ホームセンター",
      "hospital"=>"医療機関",
      "insurance_agency"=>"保険代理店",
      "jewelry_store"=>"宝石店",
      "laundry"=>"	クリーニング店, コインランドリー",
      "lawyer"=>"法律事務所",
      "library"=>"図書館",
      "liquor_store"=>"酒店",
      "local_government_office"=>"地方公共団体",
      "locksmith"=>"鍵屋",
      "lodging"=>"宿泊施設",
      "meal_delivery"=>"デリバリー飲食店",
      "meal_takeaway"=>"テイクアウト飲食店",
      "mosque"=>"モスク",
      "movie_rental"=>"レンタルビデオ店",
      "movie_theater"=>"映画館",
      "moving_company"=>"運送屋、引越し屋",
      "museum"=>"	博物館、ミュージアム",
      "night_club"=>"ナイトクラブ",
      "painter"=>"塗装屋",
      "park"=>"公園",
      "parking"=>"駐車場",
      "pet_store"=>"ペットショップ",
      "pharmacy"=>"薬局",
      "physiotherapist"=>"療法士",
      "place_of_worship"=>"神社、寺",
      "plumber"=>"配管工、水道業者",
      "police"=>"警察署、交番",
      "post_office"=>"郵便局",
      "real_estate_agency"=>"不動産業者",
      "restaurant"=>"レストラン",
      "roofing_contractor"=>"屋根屋",
      "rv_park"=>"RVパーク",
      "school"=>"学校、塾",
      "shoe_store"=>"靴屋",
      "shopping_mall"=>"ショッピングモール",
      "spa"=>"温泉、戦闘",
      "stadium"=>"スタジアム",
      "storage"=>"倉庫",
      "store"=>"店",
      "subway_station"=>"地下鉄駅",
      "synagogue"=>"シナゴーグ",
      "taxi_stand"=>"タクシー乗り場",
      "train_station"=>"鉄道駅",
      "travel_agency"=>"旅行代理店",
      "university"=>"大学",
      "veterinary_care"=>"動物病院",
      "zoo"=>"動物園"
    }
    ja_types = []
    en_types.each do |en_type|
      if @translate_ja_en_types[en_type].present?
        ja_types.push(@translate_ja_en_types[en_type])
      end
    end
    return ja_types.join('、')
  end

end
