class Admin::WishesController < ApplicationController
  before_filter :authenticate_user!, :is_admin
  layout "admin"
  
  def index
    @wished_locations = LocationsWish.all
  end
  
  def approve
    @wish_location = LocationsWish.where(location_id: params[:location_id], wish_id: params[:wish_id]).first
    
    @wish_location.wish.update_attributes(:offer_id => params[:location_id], :status => Wish::CONFIRMED)
    redirect_to admin_wishes_url
  end
  
  def cancel
    @wish_location = LocationsWish.where(location_id: params[:location_id], wish_id: params[:wish_id]).first
    
    @wish_location.wish.update_attributes(:offer_id => nil, :status => Wish::REJECTED)
    redirect_to admin_wishes_url
    
  end
end
