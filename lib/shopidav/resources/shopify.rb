require 'shopify_api'
require 'dav4rack/resource'

module Shopidav
  module Resources

    # Base class for all Shopify API resources that
    # are exposed through WebDAV.
    #
    class Shopify < ::DAV4Rack::Resource

      def exist?
        true
      end

      # Get the Rack session hash
      #
      # @return [Hash] the session data
      #
      def session
        request.env['rack.session']
      end

      # Get the {Shop} model for the current shop.
      #
      # @return [Shop] the current shop
      #
      def current_shop
        session[:current_shop]
      end

      # Get the API resource for the current shop.
      #
      # @return [ShopifyAPI::Shop] the current shop
      #
      def current_api_shop
        session[:current_api_shop]
      end

      # Authenticate the WebDAV request. On successful authentication
      # the {ShopifyAPI} is prepared for further requests.
      #
      # @param [String] username the basic auth user name
      # @param [String] username the basic auth user name
      # @return [Boolean] the authentication status
      #
      def authenticate(username, password)
        unless current_shop && current_api_shop
          session[:current_shop] = ::Shop.find_by_name("#{ request.env['HTTP_HOST'].split('.').first() }.myshopify.com")
          return false unless current_shop

          # TODO: Authenticate the user

          ShopifyAPI::Base.site = current_shop.api_url
          session[:current_api_shop] = ShopifyAPI::Shop.current
          return false unless current_api_shop
        end

        true
      end

      # Get the authentication realm
      #
      # @return [String] the name of the realm
      #
      def authentication_realm
        'Shopify WebDAV access'
      end

      # Get the error message when authentication fails
      #
      # @return [String] the error message
      #
      def authentication_error_msg
        'You are not authorized to access the Shopify shop.'
      end
    end

  end
end
