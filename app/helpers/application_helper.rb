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
    arrival_time = Time.zone.at(arrival_time_serial_num).strftime('%m/%d %Hæ%Måç')
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
      @place_opening_status[:status] = "éæ¥­"
    elsif result[:result][:business_status] == "CLOSED_TEMPORARILY"
      @place_opening_status[:status] = "èšæäŒæ¥­"
    else
      if result[:result][:opening_hours].present?
        if result[:result][:opening_hours][:open_now]
          @place_opening_status[:status] = "å¶æ¥­äž­"
          @place_opening_status[:color] = "green"
          if Date.today.wday == 0
            @place_opening_status[:time] = result[:result][:opening_hours][:weekday_text][6]
          else
            @place_opening_status[:time] = result[:result][:opening_hours][:weekday_text][Date.today.wday-1]
          end
        else
          @place_opening_status[:status] = "å¶æ¥­æéå€"
          if Date.today.wday == 0
            @place_opening_status[:time] = result[:result][:opening_hours][:weekday_text][6]
          else
            @place_opening_status[:time] = result[:result][:opening_hours][:weekday_text][Date.today.wday-1]
          end
        end
      else
        @place_opening_status[:status] = "å¶æ¥­æéãååŸã§ããŸããã§ããã"
      end
    end
    return @place_opening_status
  end

  def translate_place_types(en_types)
    @translate_ja_en_types = {
      "accounting"=>"äŒèšäºåæ",
      "airport"=>"ç©ºæž¯",
      "amusement_park"=>"éåå°",
      "aquarium"=>"æ°Žæé€š",
      "art_gallery"=>"çŸè¡é€š",
      "atm"=>"ATM",
      "bakery"=>"ãã³å±",
      "bank"=>"éè¡",
      "bar"=>"ããŒ",
      "beauty_salon"=>"çŸå®¹å®€",
      "bicycle_store"=>"èªè»¢è»å±",
      "book_store"=>"æžåº",
      "bowling_alley"=>"ããŠãªã³ã°å Ž",
      "bus_station"=>"ãã¹å",
      "cafe"=>"ã«ãã§",
      "campground"=>"ã­ã£ã³ãå Ž",
      "car_dealer"=>"èªåè»ãã£ãŒã©ãŒ",
      "car_rental"=>"ã¬ã³ã¿ã«ãŒå±",
      "car_repair"=>"	èªåè»ä¿®çãæ¿éå±",
      "car_wash"=>"æŽè»å Ž",
      "casino"=>"ã«ãžã",
      "cemetery"=>"å¢å°",
      "church"=>"æäŒ",
      "city_hall"=>"åžåœ¹æ",
      "clothing_store"=>"æŽæåº",
      "convenience_store"=>"ã³ã³ãã",
      "courthouse"=>"è£å€æ",
      "dentist"=>"æ­¯ç§",
      "department_store"=>"ãããŒã",
      "doctor"=>"å»è",
      "electrician"=>"é»æ°äºæ¥­è",
      "electronics_store"=>"é»æ°å±",
      "embassy"=>"å€§äœ¿é€š",
      "establishment"=>" ",
      "finance"=>"è²¡åæ©é¢",
      "fire_station"=>"æ¶é²çœ²",
      "florist"=>"è±å±",
      "food"=>"é£²é£åº",
      "funeral_home"=>"æå Ž",
      "furniture_store"=>"å®¶å·å±",
      "gas_station"=>"ã¬ãœãªã³ã¹ã¿ã³ã",
      "general_contractor"=>"ãŒãã³ã³",
      "grocery_or_supermarket"=>"	æ¥çšååºãã¹ãŒããŒããŒã±ãã",
      "gym"=>"ãžã ",
      "hair_care"=>"åºå±",
      "hardware_store"=>"å·¥å·åºãããŒã ã»ã³ã¿ãŒ",
      "health"=>"å»çæ©é¢",
      "hindu_temple"=>"ãã³ãã¥ãŒå¯ºé¢",
      "home_goods_store"=>"ããŒã ã»ã³ã¿ãŒ",
      "hospital"=>"å»çæ©é¢",
      "insurance_agency"=>"ä¿éºä»£çåº",
      "jewelry_store"=>"å®ç³åº",
      "laundry"=>"	ã¯ãªãŒãã³ã°åº, ã³ã€ã³ã©ã³ããªãŒ",
      "lawyer"=>"æ³åŸäºåæ",
      "library"=>"å³æžé€š",
      "liquor_store"=>"éåº",
      "local_government_office"=>"å°æ¹å¬å±å£äœ",
      "locksmith"=>"éµå±",
      "lodging"=>"å®¿æ³æœèš­",
      "meal_delivery"=>"ããªããªãŒé£²é£åº",
      "meal_takeaway"=>"ãã€ã¯ã¢ãŠãé£²é£åº",
      "mosque"=>"ã¢ã¹ã¯",
      "movie_rental"=>"ã¬ã³ã¿ã«ãããªåº",
      "movie_theater"=>"æ ç»é€š",
      "moving_company"=>"ééå±ãåŒè¶ãå±",
      "museum"=>"	åç©é€šããã¥ãŒãžã¢ã ",
      "night_club"=>"ãã€ãã¯ã©ã",
      "painter"=>"å¡è£å±",
      "park"=>"å¬å",
      "parking"=>"é§è»å Ž",
      "pet_store"=>"ãããã·ã§ãã",
      "pharmacy"=>"è¬å±",
      "physiotherapist"=>"çæ³å£«",
      "place_of_worship"=>"ç¥ç€Ÿãå¯º",
      "plumber"=>"éç®¡å·¥ãæ°Žéæ¥­è",
      "police"=>"è­Šå¯çœ²ãäº€çª",
      "post_office"=>"éµäŸ¿å±",
      "real_estate_agency"=>"äžåç£æ¥­è",
      "restaurant"=>"ã¬ã¹ãã©ã³",
      "roofing_contractor"=>"å±æ ¹å±",
      "rv_park"=>"RVããŒã¯",
      "school"=>"å­Šæ ¡ãå¡Ÿ",
      "shoe_store"=>"éŽå±",
      "shopping_mall"=>"ã·ã§ããã³ã°ã¢ãŒã«",
      "spa"=>"æž©æ³ãæŠé",
      "stadium"=>"ã¹ã¿ãžã¢ã ",
      "storage"=>"ååº«",
      "store"=>"åº",
      "subway_station"=>"å°äžéé§",
      "synagogue"=>"ã·ããŽãŒã°",
      "taxi_stand"=>"ã¿ã¯ã·ãŒä¹ãå Ž",
      "train_station"=>"ééé§",
      "travel_agency"=>"æè¡ä»£çåº",
      "university"=>"å€§å­Š",
      "veterinary_care"=>"åç©çé¢",
      "zoo"=>"åç©å"
    }
    ja_types = []
    en_types.each do |en_type|
      if @translate_ja_en_types[en_type].present?
        ja_types.push(@translate_ja_en_types[en_type])
      end
    end
    return ja_types.join('ã')
  end

end
