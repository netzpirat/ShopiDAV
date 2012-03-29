require 'shopify_api'
require 'dav4rack/resource'

module Shopidav

  # A virtual resource that assembles itself depending on the path
  # and the Shopify API resource.
  #
  class Resource < ::DAV4Rack::Resource

    # Factory method to setup the virtual resource.
    #
    def setup
      case public_path
      when /^\/$/
        @resource = Shopidav::Resources::Shop.new(self)

      when /^\/themes$/
        @resource = Shopidav::Resources::Themes.new(self)

      when /^\/themes\/(\d+)-[^\/]+$/
        @resource = Shopidav::Resources::Theme.new(self, $1.split('-').first)

      when /^\/themes\/(\d+)-[^\/]+\/([^.\n]+)$/
        @resource = Shopidav::Resources::Bucket.new(self, $1.split('-').first, $2)

      when /^\/themes\/(\d+)-[^\/]+\/((?:[^.\n]+\.)+[^.\n]+)$/
        @resource = Shopidav::Resources::Asset.new(self, $1.split('-').first, $2)

      else
        @resource = Shopidav::Resources::Ignore.new(self)

      end
    end

    # Name of the resource
    #
    # @param [String] the name
    #
    def name
      @resource.name
    end

    # Get the resource children
    #
    # @return [Array] the children
    #
    def children
      @resource.children
    end

    # Is it a collection?
    #
    # @return [Boolean] the collection status
    #
    def collection?
      @resource.collection?
    end

    # Tests if the resource exist
    #
    # @return [Boolean] the existence status
    #
    def exist?
      @resource.exist?
    end

    # Get the creation date
    #
    # @param [Date] the date
    #
    def creation_date
      @resource.creation_date
    end


    # Get the last modified date
    #
    # @param [Date] the date
    #
    def last_modified
      @resource.last_modified
    end

    # Get the etag
    #
    # @return [String] the etag
    #
    def etag
      @resource.etag
    end

    # Return the mime type of this resource.
    #
    def content_type
      @resource.content_type
    end

    # Get the file content type
    #
    # @return [String] the file content type
    #
    def content_length
      @resource.content_length
    end

    # HTTP GET request.
    # Write the content of the resource to the response.body.
    #
    # @param [Rack::Request] request the HTTP request
    # @param [Rack::Response] request the HTTP response
    # @param [Fixnum] the status code
    #
    def get(request, response)
      @resource.get(request, response)
    end

    # HTTP PUT request.
    # Save the content of the request.body.
    #
    # @param [Rack::Request] request the HTTP request
    # @param [Rack::Response] request the HTTP response
    # @param [Fixnum] the status code
    #
    def put(request, response)
      @resource.put(request, response)
    end

    # HTTP POST request.
    #
    # @param [Rack::Request] request the HTTP request
    # @param [Rack::Response] request the HTTP response
    # @param [Fixnum] the status code
    #
    def post(request, response)
      @resource.post(request, response)
    end

    # HTTP DELETE request.
    # Delete this resource.
    #
    # @param [Fixnum] the status code
    #
    def delete
      @resource.delete
    end

    # HTTP COPY request.
    # Copy this resource to given destination resource.
    #
    # @param [Shopidav::Resource] dest the target
    # @param [Boolean] overwrite should an existing target be overwritten
    # @param [Fixnum] the status code
    #
    def copy(dest, overwrite=false)
      @resource.copy(dest, overwrite)
    end

    # HTTP MOVE request.
    # Move this resource to given destination resource.
    #
    # @param [Shopidav::Resource] dest the target
    # @param [Boolean] overwrite should an existing target be overwritten
    # @param [Fixnum] the status code
    #
    def move(dest, overwrite=false)
      @resource.copy(dest, overwrite)
    end

    # Create this resource as collection.
    #
    # @param [Fixnum] the status code
    #
    def make_collection
      @resource.make_collection
    end

    # Get the resource cache store
    #
    # @return [Shopidav::Cache] the shop cache
    #
    def cache
      @cache ||= ::Shopidav::Cache.new(site)
    end

    # Get the Shopify site url
    #
    # @return [String] the site url
    #
    def site
      @site ||= ::Shop.find_by_name("#{ request.env['HTTP_HOST'].split('.').first() }.myshopify.com").api_url
    end

    # Authenticate the WebDAV request. On successful authentication
    # the {ShopifyAPI} is prepared for further requests.
    #
    # @param [String] username the basic auth user name
    # @param [String] username the basic auth user name
    # @return [Boolean] the authentication status
    #
    def authenticate(username, password)
      if site
        #TODO: Authenticate the user
        ShopifyAPI::Base.site = site
        true
      else
        false
      end
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
