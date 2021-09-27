module ApplicationHelper
  def place_photo(key)
    return "https://maps.googleapis.com/maps/api/place/photo?photo_reference=#{key}&maxwidth=1000&maxheight1000&key=#{ENV['GOOGLE_MAP_API']}"
  end

  def judge_present_place(place_id)
    @spot = Spot.find_by(user_id:current_user.id, place_id:@place_id)
    if @spot.present?
      return @spot
    else
      return nil
    end
  end

end
