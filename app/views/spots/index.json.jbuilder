json.array!(@spots) do |spot|
  json.extract! spot, :id, :name, :category, :description, :address, :tel, :url, :latitude, :longitude
  json.url spot_url(spot, format: :json)
end
