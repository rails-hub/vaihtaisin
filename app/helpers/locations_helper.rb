module LocationsHelper

  def is_selected(location)
    Wish.find_by_user_id(current_user.id).blank? ? false : LocationsWish.find_by_location_id_and_wish_id(location, Wish.find_by_user_id(current_user.id).id).blank? ? false : true
  end

  def location_name(request, type)
    if type == "from"
      return Location.find_by_id(Wish.valid_wish.find_by_id(request.wish_match_id).offer_id).name
    elsif type == "to"
      return Location.find_by_id(Wish.valid_wish.find_by_id(request.wish_by_id).offer_id).name
    end
  end

end
