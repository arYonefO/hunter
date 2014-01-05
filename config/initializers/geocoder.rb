Geocoder.configure({
  lookup: :bing,
  key: ENV['BING_GEOCODE_ID'],
  units: :km
})