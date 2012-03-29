module Shopidav

  # Defines the basic WebDAV operations as not implemented
  #
  module NotImplemented
    include DAV4Rack::HTTPStatus

    # HTTP GET request.
    # Write the content of the resource to the response.body.
    #
    # @param [Rack::Request] request the HTTP request
    # @param [Rack::Response] request the HTTP response
    # @param [Fixnum] the status code
    #
    def get(request, response)
      NotImplemented
    end

    # HTTP PUT request.
    # Save the content of the request.body.
    #
    # @param [Rack::Request] request the HTTP request
    # @param [Rack::Response] request the HTTP response
    # @param [Fixnum] the status code
    #
    def put(request, response)
      NotImplemented
    end

    # HTTP POST request.
    #
    # @param [Rack::Request] request the HTTP request
    # @param [Rack::Response] request the HTTP response
    # @param [Fixnum] the status code
    #
    def post(request, response)
      NotImplemented
    end

    # HTTP DELETE request.
    # Delete this resource.
    #
    # @param [Fixnum] the status code
    #
    def delete
      NotImplemented
    end

    # HTTP COPY request.
    # Copy this resource to given destination resource.
    #
    # @param [Shopidav::Resource] dest the target
    # @param [Boolean] overwrite should an existing target be overwritten
    # @param [Fixnum] the status code
    #
    def copy(dest, overwrite=false)
      NotImplemented
    end

    # HTTP MOVE request.
    # Move this resource to given destination resource.
    #
    # @param [Shopidav::Resource] dest the target
    # @param [Boolean] overwrite should an existing target be overwritten
    # @param [Fixnum] the status code
    #
    def move(dest, overwrite=false)
      NotImplemented
    end

    # Create this resource as collection.
    #
    # @param [Fixnum] the status code
    #
    def make_collection
      NotImplemented
    end

  end
end
