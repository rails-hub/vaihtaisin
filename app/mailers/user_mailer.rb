class UserMailer < ActionMailer::Base
  include Devise::Mailers::Helpers
  include Devise::Controllers::ScopedViews
  attr_reader :devise_mapping, :resource

  default :from => "aleksi.rossi@gmail.com"

  def notification_for_registration(user, protocol, host)
    @user = user
    @host = host
    @protocol = protocol
    @user_wished_location = user_wished_location
    @wish_log = wish_log
    @your_current_loc = your_current_loc
    mail(:to => "#{email}", :subject => "Day Care: Match Confirmation Request")
  end

  def wish_confirmation(user, wish, location, wished_locations)
    @user = user
    @wish = wish
    @location = location
    @wished_locations = wished_locations
    mail(:to => "#{user.email}", :subject => "Day Care: Wish Confirmation")
  end

  def match_confirmation_request(user, wish, match, possible_swap, email, user_wished_location, user_current_loc, your_current_loc, wish_log)
    @user = user
    @wish = wish
    @match = match
    @possible_swap = possible_swap
    @user_current_loc = user_current_loc
    @user_wished_location = user_wished_location
    @wish_log = wish_log
    @your_current_loc = your_current_loc
    mail(:to => "#{email}", :subject => "Day Care: Match Confirmation Request")
  end

  def hand_shake_confirmation(user_by, wish_log)
    @user_by = user_by
    @wish_log = wish_log
    mail(:to => "#{user_by.email}", :subject => "Day Care: Match Confirmation Request")
  end

  def mail_match_confirmation(user_by)
    @user_by = user_by
    mail(:to => "#{user_by.email}", :subject => "Day Care: Match Confirmed")
  end

  def mail_match_rejection(user_by)
    @user_by = user_by
    mail(:to => "#{user_by.email}", :subject => "Day Care: Match Rejected")
  end

  def wish_expire_query(wish, user)
    @user = user
    @wish = wish
    @expiry = wish.valid_until
    mail(:to => "#{user.email}", :subject => "Day Care: Wish is about to Expire")
  end

  def wish_weekly_update(wish, user, wish_message)
    @user = user
    @wish = wish
    @wish_message = wish_message
    mail(:to => "#{user.email}", :subject => "Day Care: Weekly Update about your Wish")
  end

  def wish_monthly_update(user, active_wishes, user_accepted_wishes, user_rejected_wishes, matched_wishes, confirmed_wishes, rejected_wishes)
    @user = user
    @active_wishes = active_wishes
    @user_accepted_wishes = user_accepted_wishes
    @user_rejected_wishes = user_rejected_wishes
    @matched_wishes = matched_wishes
    @confirmed_wishes = confirmed_wishes
    @rejected_wishes = rejected_wishes
    mail(:to => "#{user.email}", :subject => "Day Care: Monthly Updates")
  end

  def colloquial_match_request(colloquial_list,current_location, wished_location ,wish , user,colloquial_wish)
    @user = user
    @wish = wish
    @current_location = current_location
    @wished_location = wished_location
    @colloquial_list = colloquial_list
    @colloquial_wish = colloquial_wish.id
    mail(:to => "#{user.email}", :subject => "Day Care: Colloquial Match Confirmation Request")
  end

  private

  # Configure default email options
  def setup_mail(record, action)
    @scope_name = Devise::Mapping.find_scope!(record)
    @devise_mapping = Devise.mappings[@scope_name]
    @resource = instance_variable_set("@#{@devise_mapping.name}", record)

    headers = {
        :subject => translate(@devise_mapping, action),
        :from => mailer_sender(@devise_mapping),
        :to => record.email,
        :template_path => template_paths
    }

    headers.merge!(record.headers_for(action)) if record.respond_to?(:headers_for)
    mail(headers)
  end

  def mailer_sender(mapping)
    if Devise.mailer_sender.is_a?(Proc)
      Devise.mailer_sender.call(mapping.name)
    else
      Devise.mailer_sender
    end
  end

  def template_paths
    template_path = [self.class.mailer_name]
    template_path.unshift "#{@devise_mapping.plural}/mailer" if self.class.scoped_views?
    template_path
  end

  def translate(mapping, key)
    I18n.t(:"#{mapping.name}_subject", :scope => [:devise, :mailer, key],
           :default => [:subject, key.to_s.humanize])
  end
end
