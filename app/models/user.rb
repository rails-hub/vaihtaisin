class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  before_save :ensure_authentication_token

  has_many :wishes
  has_one :travel_preference
  accepts_nested_attributes_for :travel_preference
  has_one :profile
  accepts_nested_attributes_for :profile

  def self.email_permission(user)
    return user.profile.email_contact ? true : false
  end
end
