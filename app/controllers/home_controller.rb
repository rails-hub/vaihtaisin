class HomeController < ApplicationController
  def index
    @users = User.all
    @resource ||= User.new
    @wish = Wish.where('user_id = ? and valid_until >= ?', current_user.id, Date.today).first if current_user
    @c_location = Location.where('id = ?', @wish.offer_id).first unless @wish.blank?
    @saved_wish = Wish.where('user_id = ? and valid_until >= ? and saved = ?', current_user.id, Date.today, true).first if current_user
    @district = Location.find_by_id(@wish.offer_id).city unless @wish.blank?
    @location = Location.where('city = ?', @district).load unless @district.blank?
    @locations = Location.select("DISTINCT city")
    @wished_locations = LocationsWish.order("sequence_id ASC").where('wish_id = ?', @wish.id).load unless @wish.blank?
    unless @wished_locations.blank?
      @wish_logs = WishLog.where('wish_by_id = ? or wish_match_id = ?', @wish.id, @wish.id).load unless @wish.blank?
      @confirmation_request = WishLog.where('wish_match_id = ? and status = ?', @wish.id, 'ACTIVE').load unless @wish.blank?
      @hand_shake_request = WishLog.where('wish_by_id = ? and status = ?', @wish.id, 'USER_ACCEPTED').load unless @wish.blank?
    end
  end
end
