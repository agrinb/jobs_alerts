
json.(@company, :uid, :url)
json.id = @company.id
json.url = @company.url
json.extract! @company, :uid

