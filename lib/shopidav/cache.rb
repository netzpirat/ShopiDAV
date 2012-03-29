require 'uri'

module Shopidav

  # Local Redis cache of the Shopify API resources.
  # This is the only place where requests to the Shopify API takes place.
  # Each resource must be connected to the customer store by wrapping it
  # into a thread save anonymous class with the `#proxy` method.
  #
  class Cache

    attr_reader :uri

    # Initialize the cache for a shop url
    #
    # @param url [String] the url to the shop
    #
    def initialize(url)
      @url = url
      @uri = URI.parse(url)

      ShopifyAPI::Base.site = @url
    end

    # Warm up the cache
    #
    def warm_up
      Rails.info "Warm up cache for #{ @url }"

      themes.each do |theme|
        assets(theme.id) do |asset|
          asset(theme.id, asset.key)
        end
      end
    end

    # Get the current shop
    #
    def shop
      get(::ShopifyAPI::Shop, :shop) do
        PrefetchWorker.perform_async(@url)
        ::ShopifyAPI::Shop.current
      end
    end

    # Get all themes
    #
    def themes
      get(::ShopifyAPI::Theme, :themes) { ::ShopifyAPI::Theme.find(:all) }
    end

    # Get a theme
    #
    # @param id [Fixnum] the theme id
    #
    def theme(id)
      get(::ShopifyAPI::Theme, :theme, id) { ::ShopifyAPI::Theme.find(id) }
    end

    # Get all assets
    #
    # @param id [Fixnum] the theme id
    #
    def assets(id)
      get(::ShopifyAPI::Asset, :assets, id) { ::ShopifyAPI::Asset.find(:all, params: { theme_id: id }) }
    end

    # Get a asset
    #
    # @param id [Fixnum] the theme id
    # @param key [String] the asset key
    #
    def asset(id, key)
      get(::ShopifyAPI::Asset, :assets, id, key) { ::ShopifyAPI::Asset.find(key, params: { theme_id: id }) }
    end

    # Get a resource by name from the cache and fetch it to the
    # cache if not found.
    #
    # @param [Class] clazz the name of the resource clazz
    # @param [String, Symbol] name the name of the resource
    # @yield to fetch the resource
    # @yieldreturn the resource to cache
    # @return [Hash] the resource as Hash
    #
    def get(clazz, *names)
      keys = name.dup
      key = keys.unshift(uri.hostname).join(':')
      data = Sidekiq.redis { |r| r.get(key) }

      if data
        Rails.logger.debug "Get resource #{ key } from Redis cache"
        data = JSON.parse(data)

        if data.is_a?(Hash)
          resource = clazz.new(data)
          resource.instance_variable_set(:@persisted, true)
          resource

        else data.is_a?(Array)
          data.inject([]) do |result, ar|
            resource = clazz.new(ar)
            resource.instance_variable_set(:@persisted, true)
            result << resource
          end
        end

      else
        Rails.logger.debug "Get resource #{ key } from Shopify API"
        put(yield, names)
      end
    end

    # Put a resource into the cache
    #
    # @param [Object] resource a resource that responds to_json
    # @param [String, Symbol] name the name of the resource
    # @return [Object] the resource
    #
    def put(resource, *names)
      key = names.unshift(uri.hostname).join(':')
      Rails.logger.debug "Put resource #{ key } into the cache"

      Sidekiq.redis do |r|
        r.set key, resource.to_json
        r.expire key, 10 * 60
      end

      resource
    end


  end
end
