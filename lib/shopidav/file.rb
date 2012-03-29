require 'shopify_api'
require 'mime/types'

module Shopidav

  # Common DAV file handling that can be included
  # into a resource representation.
  #
  module File
    include Shopidav::NotImplemented

    # Is it a collection?
    #
    # @return [Boolean] the collection status
    #
    def collection?
      false
    end

    # Get the resource children
    #
    # @return [Array] the children
    #
    def children
      []
    end

    # Get the etag
    #
    # @return [String] the etag
    #
    def etag
      Time.new.to_i
    end

    # Get the file content type
    #
    # @return [String] the file content type
    #
    def content_type
      ::MIME::Types.type_for(name).first.try(:content_type) || 'text/html'
    end

  end
end
