require 'time'

module Shopidav
  module Resources

    # A folder with themes: http://api.shopify.com/theme.html
    #
    class Themes
      include Shopidav::Folder

      attr_reader :resource

      # Initialize the themes
      #
      # @param [Shopidav::Resource] resource the base resource
      #
      def initialize(resource)
        @resource = resource
      end

      # Get the theme resources
      #
      # @return [Array<ShopifyAPI::Theme>] the Shopify theme
      #
      def themes
        @themes ||= resource.cache.themes
      end

      # Get the theme name
      #
      # @return [String] the name
      #
      def name
        'Themes'
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
        @creation_date ||= themes.map { |theme| Date.parse(theme.created_at) }.min
      end

      # Get the last modified date
      #
      # @param [Date] the date
      #
      def last_modified
        @last_modified ||= themes.map { |theme| Date.parse(theme.updated_at) }.max
      end

      # Get the resource children
      #
      # @return [Array<Shopidav::Resource>] the children
      #
      def children
        @children ||= themes.map do |theme|
          path = "#{ resource.public_path }/#{ theme.id }-#{ theme.name }"
          Shopidav::Resource.new(path, path, resource.request, resource.response, resource.options)
        end
      end

    end

  end
end
