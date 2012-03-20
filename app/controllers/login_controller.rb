# The login controller asks a shop owner for his myshopify.com address,
# so the application can be authenticated
#
class LoginController < ApplicationController

  # Show the login form, where the user can enter his shop name.
  # If the shop name is already provided in the URL, just skip to #authenticate
  #
  def index
    if params[:shop].present?
      redirect_to authenticate_path(:shop => params[:shop])
    end
  end

  # Authenticate the Shopify WebDAV application by redirecting
  # the user to the Shopify app authorization page.
  #
  def authenticate
    if params[:shop].present?
      redirect_to ShopifyAPI::Session.new(params[:shop].to_s.strip).create_permission_url
    else
      redirect_to return_address
    end
  end

  # Shopify redirects the logged-in user back to this action along with
  # the authorization token `t`.
  #
  # This token is later combined with the developer's shared secret to form
  # the password used to call API methods.
  #
  def finalize
    shopify_session = ShopifyAPI::Session.new(params[:shop], params[:t], params)

    if shopify_session.valid?
      session[:shopify] = shopify_session
      flash[:notice] = 'Logged in to shopify store.'

      Shop.find_or_create_by_name_and_api_url(params[:shop], shopify_session.site)

      redirect_to return_address
      session[:return_to] = nil
    else
      flash[:error] = 'Could not log in to Shopify store.'
      redirect_to :action => 'index'
    end
  end

  # Logout the current user.
  #
  def logout
    session[:shopify] = nil
    flash[:notice] = 'Successfully logged out.'

    redirect_to :action => 'index'
  end

  protected

  def return_address
    session[:return_to] || root_url
  end
end
