module Shopidav
  module Resources

    # http://api.shopify.com/asset.html
    #
    class Bucket
      include Shopidav::Folder

      attr_reader :resource, :theme_id, :bucket

      def initialize(resource, theme_id, bucket)
        @resource = resource
        @theme_id = theme_id
        @bucket = bucket
      end

      def assets
        @assets ||= resource.cache.assets(theme_id)
      end

      def name
        @bucket
      end

      def etag
        @etag ||= last_modified.to_time.to_i
      end

      def creation_date
        @creation_date ||= assets.map { |asset| Date.parse(asset.created_at) }.min
      end

      def last_modified
        @last_modified ||= assets.map { |asset| Date.parse(asset.updated_at) }.max
      end

      def children
        @children ||= assets.map do |asset|
          if asset.key.split('/').first == bucket
            path = "#{ resource.public_path }/#{ asset.key.split('/').last }"
            Shopidav::Resource.new(path, path, resource.request, resource.response, resource.options)
          end
        end.compact
      end

    end

  end
end
