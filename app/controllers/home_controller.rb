# The Home controller shows the home page when
# the user is logged into the ShopiDAV app.
#
class HomeController < ApplicationController

  around_filter :shopify_session

  def index
  end

end
