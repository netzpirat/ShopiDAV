require 'shopify_api'

module Shopidav
  module Folder

    def collection?
      true
    end

    def content_length
      4096
    end

    def content_type
      'httpd/unix-directory'
    end

    def children
      []
    end

    def etag
      Time.new.to_i
    end

    def exist?
      true
    end

  end
end
