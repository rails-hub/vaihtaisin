class Wish < ActiveRecord::Base

  has_many :locations, :through => :locations_wishes
  belongs_to :user
  belongs_to :offer, class_name: Location
  
  ACTIVE = "ACTIVE"
  DISABLED = "DISABLED"
  EXPIRED = "EXPIRED"
  CONFIRMED = "CONFIRMED"
  REJECTED = "REJECTED"

  scope :valid_wish, -> { where('valid_until >= ? and saved = ?', Date.today, true) }
  scope :valid_wish_date, -> { where('valid_until >= ?', Date.today) }

  def self.wish_expire_query
    wishes = Wish.where('(status = ? or status = ?)and saved = ?', 'ACTIVE', 'MATCH_WAIT', true).all
    unless wishes.blank?
      wishes.each do |wish|
        if wish.valid_until.to_date < Date.today
          wish.update_attributes(:status => "EXPIRED")
        elsif wish.valid_until.to_date < Date.today + 1.week
          UserMailer.wish_expire_query(wish, wish.user).deliver!
        end
      end
    end
  end

  def self.wish_weekly_update
    wishes = Wish.where('(status != ? and status != ?) and saved = ?', 'EXPIRED', 'REJECTED', true).all
    unless wishes.blank?
      wishes.each do |wish|
        wish_message = self.status_wish_message(wish)
        UserMailer.wish_weekly_update(wish, wish.user, wish_message).deliver!
      end
    end
  end

  def self.wish_monthly_update
    users = User.all
    wish_logs = WishLog.all
    unless users.blank? or wish_logs.blank?
      active_wishes = WishLog.where('status = ?', "ACTIVE").all
      user_accepted_wishes = WishLog.where('status = ?', "USER_ACCEPTED").all
      user_rejected_wishes = WishLog.where('status = ?', "USER_REJECTED").all
      matched_wishes = WishLog.where('status = ?', "MATCH").all
      confirmed_wishes = WishLog.where('status = ?', "CONFIRMED").all
      rejected_wishes = WishLog.where('status = ?', "REJECTED").all
      users.each do |user|
        UserMailer.wish_monthly_update(user, active_wishes, user_accepted_wishes, user_rejected_wishes, matched_wishes, confirmed_wishes, rejected_wishes).deliver!
      end
    end
  end

  private

  def self.status_wish_message(wish)
    if wish.status == "ACTIVE"
      message = "Your Wish is in Process, we will get back to you as soon as we find a match for your wished location."
    elsif wish.status == "MATCH"
      message = "Your Wish has been sent to City Government approval, we will get back to you as soon as hear from them."
    elsif wish.status == "MATCH_WAIT"
      message = "Your Wish request has been sent to the user. We will get back to you as soon as the user Accepts/Rejects it."
    elsif wish.status == "ACCEPT_WAIT"
      message = "You got pending wish accept request(s). Please accept it to confirm the location swap."
    elsif wish.status == "CONFIRMED"
      message = "Your wish has been approved by City Government."
    elsif wish.status == "REJECTED"
      message = "Your wish has been rejected by City Government."
    end
  end
end
