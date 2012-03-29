module Shopidav
  module Resources

    # A bucket is the directory part from an asset key: http://api.shopify.com/asset.html
    #
    class Bucket
      include Shopidav::Folder

      attr_reader :resource, :theme_id, :bucket

      # Initialize an asset
      #
      # @param [Shopidav::Resource] resource the base resource
      # @param [Fixnum] theme_id the id of the theme where the asset belongs to
      # @param [String] bucket the bucket name
      #
      def initialize(resource, theme_id, bucket)
        @resource = resource
        @theme_id = theme_id
        @bucket = bucket
      end

      # Get the assets
      #
      # @return [Array<ShopifyAPI::Asset>] the asset resources
      #
      def assets
        @assets ||= resource.cache.assets(theme_id)
      end

      # Get the bucket/directory name
      #
      # @param [String] the name
      #
      def name
        @bucket
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
        @creation_date ||= assets.map { |asset| Date.parse(asset.created_at) }.min
      end

      # Get the last modified date
      #
      # @param [Date] the date
      #
      def last_modified
        @last_modified ||= assets.map { |asset| Date.parse(asset.updated_at) }.max
      end

      # Get the resource children, either more buckets or assets.
      #
      # @return [Array] the children
      #
      def children
        @children ||= assets.map do |asset|
          if %r{^#{ bucket }\/([^\/]+)} === asset.key
            path = "#{ resource.public_path }/#{ $1 }"
            Shopidav::Resource.new(path, path, resource.request, resource.response, resource.options)
          end
        end.compact.uniq_by { |asset| asset.path }
      end

    end

  end
end
