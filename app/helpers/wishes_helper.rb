module WishesHelper

  def wish_status?(wish)
    if wish.blank?
      return true
    else
      if wish.saved
        return false
      else
        return true
      end
    end
  end

end
