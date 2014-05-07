class LocationsWish < ActiveRecord::Base
  belongs_to :wish
  belongs_to :location

  def self.add_sequence(locations_wish)
    seq = LocationsWish.order("sequence_id DESC").where('wish_id = ? and id != ?', locations_wish.wish_id, locations_wish.id).all.first
    locations_wish.update_attributes(:sequence_id => seq.blank? ? 1 : seq.sequence_id + 1)
  end

  def self.find_match(current_user, wish, wished_locations)
    colloquial_list = []
    wished_locations.each do |wished_location|
      # find if there is any user has his current location which is also one of my wished location
      matches = Wish.valid_wish.where('offer_id = ? and user_id != ? and status = ?', wished_location.location_id, current_user.id, "ACTIVE").load
      # due to checking on wish status we are limited to a condition which is that once a user initiates and
      # gets away with ACTIVE status then he will not receive any other wish requests.
      found = false
      unless matches.blank?
        # find if above user wants to have a wished location that is my current location
        matches.each do |match|
          possible_swap = LocationsWish.where('wish_id = ? and location_id = ?', match.id, wish.offer_id).first
          #puts "SSSSSSSSSSSSSSSSSSSSSSSSSS33333333333", possible_swap.inspect
          unless possible_swap.blank?
            wish_log = WishLog.find_or_create_by(wish_by_id: wish.id, wish_match_id: match.id, status: "ACTIVE")
            UserMailer.match_confirmation_request(possible_swap.wish.user, wish, match, possible_swap, match.user.email, wished_location.location.name, Location.find_by_id(wished_location.wish.offer_id).name, wished_location.location.name, wish_log.id).deliver! unless possible_swap.blank?
            found = true
          end
        end
      end

      if !found
        coll_matches = LocationsWish.where('location_id = ?', wish.offer_id).load
        unless coll_matches.blank?
          coll_matches.each do |c_match|
            colloquial_list = []
            colloquial_list << c_match
            self.get_colloquial(c_match, wish, colloquial_list)
          end
        end
      end
    end
    #puts "Colloquial LISSSSSSSSSSSSSSSSSSTT", colloquial_list.inspect
  end

  private
  def self.get_colloquial(c_match, wish, colloquial_list)
    puts "colloquial_list", colloquial_list.inspect
    match_loop = LocationsWish.where('location_id = ?', c_match.wish.offer_id).load
    unless match_loop.blank?
      match_loop.each do |m_loop|
        colloquial_list << m_loop
        if m_loop.wish.offer_id == wish.offer_id
          puts "Colloquial Match Found", colloquial_list.inspect
          colloquial_list.each_with_index do |c_list, index|
            wish_log = WishLog.find_or_create_by(wish_by_id: wish.id, :wish_match_id => c_list["wish_id"] ,status: "ACTIVE", :colloquial => true)
            colloquial_wish = ColloquialWish.new(wish_by_id: wish.id,:wish_match_id => c_list["wish_id"], :wish_log_id => wish_log.id)
            colloquial_wish.save!
            mail_to = Wish.find_by_id(c_list["wish_id"])
            wished_loc = Location.find_by_id(c_list["location_id"])
            current_loc = Location.find_by_id(wish.offer_id)
            UserMailer.colloquial_match_request(colloquial_list, current_loc, wished_loc, mail_to, mail_to.user, colloquial_wish).deliver!
          end
          return true
        else
          self.get_colloquial(m_loop, wish, colloquial_list)
        end
      end
    else
      colloquial_list.delete(c_match)
    end
  end

  #wafaqi -> gulberg - rails 1
  #gulberg -> iqbal  - saqib 2
  #iqbal -> wafaqi   - saki 1

  #gulberg -> quetta - saqib 2
  #quetta -> gulberg - hot  1


end