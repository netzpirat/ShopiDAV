module Shopidav
  module Resources

    # http://api.shopify.com/asset.html
    #
    class Asset
      include Shopidav::File

      def initialize(resource, theme_id, asset_key)
        @resource  = resource
        @theme_id  = theme_id
        @asset_key = asset_key
      end

      def theme
        @theme ||= ShopifyAPI::Theme.find(@theme_id)
      end

      def asset
        @asset ||= ShopifyAPI::Asset.find(@asset_key, :params => { :theme_id => @theme_id })

      rescue ActiveResource::ResourceNotFound
        nil
      end

      def exist?
        asset ? true : false
      end

      def name
        asset.key.split('/').last
      end

      def etag
        @etag ||= last_modified.to_time.to_i
      end

      def creation_date
        @creation_date ||= Date.parse(asset.created_at)
      end

      def last_modified
        @last_modified ||= Date.parse(asset.created_at)
      end

      def content
        asset.value || asset.attachment
      end

      def content_length
        content.try(:bytesize) || 0
      end

      def get(request, response)
        response.body = content

        OK
      end

      def put(request, response)
        return unless exist?

        asset.value = request.body.read
        asset.save

        Created
      end

    end

  end
end
