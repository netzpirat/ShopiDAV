module Shopidav
  module Resources

    # Represents a theme folder: http://api.shopify.com/theme.html
    #
    class Theme
      include Shopidav::Folder

      attr_reader :resource, :theme_id

      # Initialize an asset
      #
      # @param [Shopidav::Resource] resource the base resource
      # @param [Fixnum] theme_id the id of the theme
      #
      def initialize(resource, theme_id)
        @resource = resource
        @theme_id = theme_id
      end

      # Get the asset resource
      #
      # @return [ShopifyAPI::Theme] the Shopify theme
      #
      def theme
        @theme ||= resource.cache.theme(theme_id)
      end

      # Get the asset resources
      #
      # @return [Array<ShopifyAPI::Asset>] the Shopify theme
      #
      def assets
        @assets ||= resource.cache.assets(theme_id)
      end

      # Get the theme name
      #
      # @return [String] the name
      #
      def name
        theme.name
      end

      # Get the etag
      #
      # @return [String] the etag
      #
      def etag
        @etag ||= last_modified.to_time.to_i
      end

      # Get the creation date
      #
      # @param [Date] the date
      #
      def creation_date
        @creation_date ||= Date.parse(theme.created_at)
      end

      # Get the last modified date
      #
      # @param [Date] the date
      #
      def last_modified
        @last_modified ||= Date.parse(theme.created_at)
      end

      # Get the resource children
      #
      # @return [Array<Shopidav::Resource>] the children
      #
      def children
        @children ||= assets.map { |asset| asset.key.split('/').first }.uniq.map do |bucket|
          path = "#{ resource.public_path }/#{ bucket }"
          Shopidav::Resource.new(path, path, resource.request, resource.response, resource.options)
        end
      end

    end

  end
end
