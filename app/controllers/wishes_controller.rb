class WishesController < ApplicationController
  before_action :set_wish, only: [:show, :edit, :update, :destroy, :order_wished_locations]
  before_filter :authenticate_user!
  # GET /wishes
  # GET /wishes.json
  def index
    @wishes = Wish.valid_wish.all
  end

  # GET /wishes/1
  # GET /wishes/1.json
  def show
  end

  # GET /wishes/new
  def new
    @wish = Wish.new
    @wish.user = current_user
    @wish.valid_until = Date.today + 1.months
  end

  # GET /wishes/1/edit
  def edit
  end

  # POST /wishes
  # POST /wishes.json
  def create
    @wish = Wish.new(wish_params)
    @wish.user = current_user

    respond_to do |format|
      if @wish.save
        format.html { redirect_to @wish, notice: 'Wish was successfully created.' }
        format.json { render action: 'show', status: :created, location: @wish }
      else
        format.html { render action: 'new' }
        format.json { render json: @wish.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wishes/1
  # PATCH/PUT /wishes/1.json
  def update
    respond_to do |format|
      if @wish.update(wish_params)
        format.html { redirect_to @wish, notice: 'Wish was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @wish.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wishes/1
  # DELETE /wishes/1.json
  def destroy
    LocationsWish.where('wish_id = ?', @wish.id).all.each do |wish|
      wish.destroy
    end
    WishLog.where('wish_by_id= ?', @wish.id).all.each do |wish|
      wish.destroy
    end
    @wish.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  def confirm_wish
    wish = Wish.valid_wish_date.find_by_id(params[:wish_id])
    wish.update_attributes(:saved => true)
    wished_locations = LocationsWish.where('wish_id = ?', wish.id).load
    UserMailer.wish_confirmation(current_user, wish, Location.find_by_id(wish.offer_id), wished_locations).deliver!
    LocationsWish.find_match(current_user, wish, wished_locations)
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  def order_wished_locations
    params[:order_wish_locations].split(',').each_with_index do |location_id, index|
      locations_wish = LocationsWish.where('wish_id = ? and location_id = ?', @wish.id, location_id).first
      locations_wish.update_attributes(:sequence_id => index + 1)
    end
    @wished_locations = LocationsWish.order("sequence_id ASC").where('wish_id = ?', @wish.id).all
    @c_location = Location.where('id = ?', @wish.offer_id).first unless @wish.blank?
    render :partial => 'locations/ordered_wish_locations'
  end

  def accept_match_request
    wish_log = WishLog.find_by_id(params[:wish_log])
    if params[:user_id].to_i == current_user.id
      any_matched = Wish.valid_wish.where('user_id = ? and status = ?', current_user.id, "MATCH")
      if any_matched.blank?
        unless wish_log.blank?
          wish_by = Wish.valid_wish.find_by_id(wish_log.wish_by_id)
          wish = Wish.valid_wish.find_by_id(wish_log.wish_match_id)
          unless wish.blank? or wish_by.blank?
            if active_wish?(wish_log, wish, wish_by)
              wish_log.update_attributes(:status => "USER_ACCEPTED")
              wish.update_attributes(:status => "MATCH_WAIT")
              wish_by.update_attributes(:status => "ACCEPT_WAIT")
              UserMailer.hand_shake_confirmation(wish_by.user, wish_log).deliver!
            end
          end
        end
      end
    end
    redirect_to root_url
  end

  def hand_shake_confirmation
    wish_log = WishLog.find_by_id(params[:wish_log])
    if params[:user_id].to_i == current_user.id
      any_matched = Wish.valid_wish.where('user_id = ? and status = ?', current_user.id, "MATCH")
      if any_matched.blank?
        unless wish_log.blank?
          wish_by = Wish.valid_wish.find_by_id(wish_log.wish_by_id)
          wish = Wish.valid_wish.find_by_id(wish_log.wish_match_id)
          unless wish.blank? or wish_by.blank?
            if accepted_wish?(wish_log, wish, wish_by)
              wish_log.update_attributes(:status => "MATCH")
              wish_by.update_attributes(:status => "MATCH")
              UserMailer.mail_match_confirmation(wish.user).deliver!
              UserMailer.mail_match_confirmation(wish_by.user).deliver!
              # other pending wishes may now go Active(Initial State) now for both of the user
              active_rejected_wish(wish_by, wish_log)
              active_rejected_wish(wish, wish_log)
            end
          end
        end
      end
    end
    redirect_to root_url
  end


  def extend_expiry
    wish = Wish.find_by_id(params[:id])
    unless wish.blank?
      if wish.status != "EXPIRED"
        if wish.valid_until.to_date < Date.today + 1.week
          wish.update_attributes(:valid_until => wish.valid_until + 1.month)
        end
      end
    end
    redirect_to root_url
  end

  def colloquial_confirmation
    if params[:user_id].to_i == current_user.id
      any_matched = Wish.where('user_id = ? and status = ?', current_user.id, "MATCH")
      if any_matched.blank?
        colloquial_wish = ColloquialWish.find_by_id(params[:colloquial_wish_id])
        colloquial_wish.update_attributes(:status => true)
        colloquial_wishes = ColloquialWish.where(:wish_by_id => colloquial_wish.wish_by_id, :status => false).load
        wish_log = WishLog.find_by_id(colloquial_wish.wish_log_id)
        wish_log.update_attributes(:status => "USER_ACCEPTED")
        if colloquial_wishes.blank? || colloquial_wishes.nil?
          wish_logs = WishLog.where(:wish_by_id => colloquial_wish.wish_by_id).load
          wish_logs.each do |w_log|
            w_log.update_attributes(:status => "MATCH")
            wish = Wish.find_by_id(w_log.wish_by_id)
            wish.update_attributes(:status => "MATCH") unless wish.blank?
            UserMailer.mail_match_confirmation(wish.user).deliver!
            active_rejected_wish(wish, wish_log)
          end
        end
        flash[:notice] = "You successfully accepted the colloquial process request."
      end
    end
    redirect_to root_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def active_wish?(wish_log, wish, wish_by)
    return wish_log.status == "ACTIVE" ? wish.status == "ACTIVE" ? wish_by.status == "ACTIVE" ? true : false : false : false
  end

  def accepted_wish?(wish_log, wish, wish_by)
    return wish.status == "MATCH_WAIT" ? wish_by.status == "ACCEPT_WAIT" ? wish_log.blank? ? false : wish_log.status == "USER_ACCEPTED" ? true : false : false : false
  end

  def active_rejected_wish(wish, wish_log)
    other_wish_log = WishLog.where('wish_by_id = ? and id != ?', wish.id, wish_log.id).all
    unless other_wish_log.blank?
      other_wish_log.each do |log_wish|
        log_wish.update_attributes(:status => "USER_REJECTED")
        other_wish = Wish.valid_wish.find_by_id(log_wish.wish_match_id)
        other_wish.update_attributes(:status => "ACTIVE") unless other_wish.blank?
        colloquial_wish = ColloquialWish.find_by_wish_log_id(log_wish.id)
        colloquial_wish.update_attributes(:status => false) unless colloquial_wish.blank?
        UserMailer.mail_match_rejection(other_wish.user).deliver! unless other_wish.blank?
      end
    end
  end

  def set_wish
    @wish = Wish.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def wish_params
    params.require(:wish).permit(:user, :offer, :valid_until)
  end

end
