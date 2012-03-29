module Shopidav
  module Resources

    # A shop representation http://api.shopify.com/shop.html
    # Includes only virtual folders.
    #
    class Shop
      include Shopidav::Folder

      attr_reader :resource

      # Initialize an asset
      #
      # @param [Shopidav::Resource] resource the base resource
      #
      def initialize(resource)
        @resource = resource
      end

      # Get the shop resource
      #
      # @return [ShopifyAPI::Shop] the Shopify shop
      #
      def shop
        @shop ||= resource.cache.shop
      end

      # Get the name of the shop
      #
      # @return [String] the name
      #
      def name
        shop.name
      end

      # Get the creation date
      #
      # @param [Date] the date
      #
      def creation_date
        @creation_date ||= Date.parse(shop.created_at)
      end

      # Get the last modified date
      #
      # @param [Date] the date
      #
      def last_modified
        @last_modified ||= Date.parse(shop.created_at)
      end

      # Get the resource children
      #
      # @return [Array<Shopidav::Resource>] the children
      #
      def children
        @children ||= [
          Shopidav::Resource.new('/themes', '/themes', resource.request, resource.response, resource.options)
        ]
      end
    end

  end
end
