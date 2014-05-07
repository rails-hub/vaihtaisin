class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all
  end

  def locations
    @location = Location.where('city = ? and id != ?', params[:id], params[:not_location]).load if params[:wish]
    @c_location = Location.where('id = ?', params[:not_location]).first if params[:wish]
    @location = Location.where('city = ?', params[:id]).load unless params[:wish]
    @wish = Wish.where('user_id = ? and valid_until >= ?', current_user.id, Date.today).first unless current_user.blank?
    render :partial => 'shared/locations' unless params[:wish]
    render :partial => 'shared/locations_map' if params[:wish]
  end

  def ordered_wishes
    @wish = Wish.find_or_create_by_user_id(:user_id => current_user.id, :offer_id => params[:location], :valid_until => params[:valid_until].to_datetime)
    @c_location = Location.where('id = ?', @wish.offer_id).first
    location = Location.find_by_id(params[:id])
    locations_wish = LocationsWish.find_or_create_by_wish_id_and_location_id(@wish.id, location.id)
    LocationsWish.add_sequence(locations_wish)
    @wished_locations = LocationsWish.where('wish_id = ?', @wish.id).load
    render :partial => 'locations/ordered_wish_locations'
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def location_params
    params.require(:location).permit(:name, :area1, :area2, :caretype, :streetaddress, :streetnumber, :pobox, :zipcode, :ziparea, :city, :phone, :email, :supervisor, :supervisoremail, :supervisorphone, :capacity)
  end

end
