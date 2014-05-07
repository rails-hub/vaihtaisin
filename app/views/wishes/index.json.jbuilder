json.array!(@wishes) do |wish|
  json.extract! wish, :user, :offer, :valid_until
  json.url wish_url(wish, format: :json)
end
