module Shopidav
  module Resources

    # http://api.shopify.com/shop.html
    #
    class Shop
      include Shopidav::Folder

      def initialize(resource)
        @resource = resource
      end

      def shop
        @shop ||= @resource.current_api_shop
      end

      def name
        shop.name
      end

      def creation_date
        @creation_date ||= Date.parse(shop.created_at)
      end

      def last_modified
        @last_modified ||= Date.parse(shop.created_at)
      end

      def children
        @children ||= [
          Shopidav::Resource.new('/themes', '/themes', @resource.request, @resource.response, @resource.options)
        ]
      end
    end

  end
end
