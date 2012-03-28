module Shopidav
  module Resources

    # http://api.shopify.com/theme.html
    #
    class Theme
      include Shopidav::Folder

      attr_reader :resource, :theme_id

      def initialize(resource, theme_id)
        @resource = resource
        @theme_id = theme_id
      end

      def theme
        @theme ||= resource.cache.theme(theme_id)
      end

      def assets
        @assets ||= resource.cache.assets(theme_id)
      end

      def name
        theme.name
      end

      def etag
        @etag ||= last_modified.to_time.to_i
      end

      def creation_date
        @creation_date ||= Date.parse(theme.created_at)
      end

      def last_modified
        @last_modified ||= Date.parse(theme.created_at)
      end

      def children
        @children ||= assets.map { |asset| asset.key.split('/').first }.uniq.map do |bucket|
          path = "#{ resource.public_path }/#{ bucket }"
          Shopidav::Resource.new(path, path, resource.request, resource.response, resource.options)
        end
      end

    end

  end
end
