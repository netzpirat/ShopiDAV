module Shopidav
  module Resources

    # A resource that just ignores all operations
    # by sending success status.
    #
    class Ignore
      include DAV4Rack::HTTPStatus

      attr_reader :resource

      # Initialize an inexistent resource to be ignored.
      #
      # @param [Shopidav::Resource] resource the base resource
      # @param [Fixnum] theme_id the id of the theme where the asset belongs to
      # @param [String] asset_key the key of the asset
      #
      def initialize(resource)
        @resource  = resource
      end

      # HTTP GET request.
      # Write the content of the resource to the response.body.
      #
      # @param [Rack::Request] request the HTTP request
      # @param [Rack::Response] request the HTTP response
      # @param [Fixnum] the status code
      #
      def get(request, response)
        OK
      end

      # HTTP PUT request.
      # Save the content of the request.body.
      #
      # @param [Rack::Request] request the HTTP request
      # @param [Rack::Response] request the HTTP response
      # @param [Fixnum] the status code
      #
      def put(request, response)
        Created
      end

      # HTTP POST request.
      #
      # @param [Rack::Request] request the HTTP request
      # @param [Rack::Response] request the HTTP response
      # @param [Fixnum] the status code
      #
      def post(request, response)
        OK
      end

      # HTTP DELETE request.
      # Delete this resource.
      #
      # @param [Fixnum] the status code
      #
      def delete
        Deleted
      end

      # HTTP COPY request.
      # Copy this resource to given destination resource.
      #
      # @param [Shopidav::Resource] dest the target
      # @param [Boolean] overwrite should an existing target be overwritten
      # @param [Fixnum] the status code
      #
      def copy(dest, overwrite=false)
        OK
      end

      # HTTP MOVE request.
      # Move this resource to given destination resource.
      #
      # @param [Shopidav::Resource] dest the target
      # @param [Boolean] overwrite should an existing target be overwritten
      # @param [Fixnum] the status code
      #
      def move(dest, overwrite=false)
        OK
      end

      # Create this resource as collection.
      #
      # @param [Fixnum] the status code
      #
      def make_collection
        OK
      end

    end

  end
end
