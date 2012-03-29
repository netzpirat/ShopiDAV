module Shopidav
  module Resources

    # A shopify asset retreived from {http://api.shopify.com/asset.html}.
    # A asset has a key that can contain a full file path. This resource
    # representation is for the file part of the asset key, the directory
    # is wrapped by a {Shopidav::Resources::Bucket}
    #
    class Asset
      include Shopidav::File

      attr_reader :resource, :theme_id, :asset_key

      # Initialize an asset
      #
      # @param [Shopidav::Resource] resource the base resource
      # @param [Fixnum] theme_id the id of the theme where the asset belongs to
      # @param [String] asset_key the key of the asset
      #
      def initialize(resource, theme_id, asset_key)
        @resource  = resource
        @theme_id  = theme_id
        @asset_key = asset_key
      end

      # Get the asset theme resource
      #
      # @return [ShopifyAPI::Theme] the Shopify theme
      #
      def theme
        @theme ||= resource.cache.theme(theme_id)
      end

      # Get the asset resource
      #
      # @return [ShopifyAPI::Asset] the asset resource
      #
      def asset
        @asset ||= resource.cache.asset(theme_id, asset_key)
      end

      # Does the resource exist?
      #
      # @return [Boolean] the existence status
      #
      def exist?
        asset ? true : false
      rescue ActiveResource::ResourceNotFound
        false
      end

      # Get the file name of the asset
      #
      # @return [String] the file name
      #
      def name
        asset.key.split('/').last
      end

      # Get the etag
      #
      # @param [String] the asset etag
      #
      def etag
        @etag ||= last_modified.to_time.to_i
      end

      # Get the creation date
      #
      # @param [Date] the date
      #
      def creation_date
        @creation_date ||= Date.parse(asset.created_at)
      end

      # Get the last modified date
      #
      # @param [Date] the date
      #
      def last_modified
        @last_modified ||= Date.parse(asset.created_at)
      end

      # Get the content of the asset
      #
      # @param [String] the content
      #
      def content
        asset.value || asset.attachment
      end

      # Get the content length of the asset
      #
      # @return [Fixnum] the byte size
      #
      def content_length
        content.try(:bytesize) || 0
      end

      # Get the asset.
      #
      # @param [Rack::Request] request the HTTP request
      # @param [Rack::Response] request the HTTP response
      # @param [Fixnum] the status code
      #
      def get(request, response)
        response.body = content

        OK
      end

      # Create or update an asset
      #
      # @param [Rack::Request] request the HTTP request
      # @param [Rack::Response] request the HTTP response
      # @param [Fixnum] the status code
      #
      def put(request, response)
        if exist?
          asset.value = request.body.read
          asset.save

          OK
        else
          @asset = ::ShopifyAPI::Asset.create({ key: asset_key, value: request.body.read })
          resource.cache.put(@asset, :assets, theme_id, asset_key)

          Created
        end
      end

      # Delete the asset remotely
      #
      # @param [Fixnum] the status code
      #
      def delete
        asset.destroy

        Deleted
      end

    end

  end
end
