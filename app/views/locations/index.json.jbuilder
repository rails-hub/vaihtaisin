json.array!(@locations) do |location|
  json.extract! location, :name, :area1, :area2, :caretype, :streetaddress, :streetnumber, :pobox, :zipcode, :ziparea, :city, :phone, :email, :supervisor, :supervisoremail, :supervisorphone, :capacity
  json.url location_url(location, format: :json)
end
