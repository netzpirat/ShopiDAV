require 'shopify_api'
require 'mime/types'

module Shopidav
  module File
    include DAV4Rack::HTTPStatus

    def collection?
      false
    end

    def children
      []
    end

    def etag
      Time.new.to_i
    end

    def content_type
      ::MIME::Types.type_for(name).first.try(:content_type) || 'text/html'
    end

  end
end
