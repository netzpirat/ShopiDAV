module Shopidav
  module Resources

    # Base class for API resources that can be accessed
    # as folder resource.
    #
    class Folder < ::Shopidav::Resources::Shopify

      def collection?
        true
      end

      def content_length
        4096
      end

      def content_type
        'httpd/unix-directory'
      end

      def get(request, response)
        response.body = ""
        response['Content-Length'] = response.body.bytesize.to_s
      end

    end

  end
end


