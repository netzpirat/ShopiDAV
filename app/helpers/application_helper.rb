module ApplicationHelper

  def shopidav_url
    "http://#{ session[:shopify].url.split('.').first }.shopidav.com"
  end

end
