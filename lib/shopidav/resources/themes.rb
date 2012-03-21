require 'time'

module Shopidav
  module Resources

    # http://api.shopify.com/theme.html
    #
    class Themes
      include Shopidav::Folder

      def initialize(resource)
        @resource = resource
      end

      def themes
        @themes ||= ShopifyAPI::Theme.find(:all)
      end

      def name
        'Themes'
      end

      def etag
        @etag ||= last_modified.to_time.to_i
      end

      def creation_date
        @creation_date ||= themes.map { |theme| Date.parse(theme.created_at) }.min
      end

      def last_modified
        @last_modified ||= themes.map { |theme| Date.parse(theme.updated_at) }.max
      end

      def children
        @children ||= themes.map do |theme|
          path = "#{ @resource.public_path }/#{ theme.id }-#{ theme.name }"
          Shopidav::Resource.new(path, path, @resource.request, @resource.response, @resource.options)
        end
      end

    end

  end
end
