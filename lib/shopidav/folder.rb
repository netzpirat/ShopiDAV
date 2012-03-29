require 'shopify_api'

module Shopidav

  # Common folder file handling that can be included
  # into a resource representation.
  #
  module Folder
    include Shopidav::NotImplemented

    # Is it a collection?
    #
    # @return [Boolean] the collection status
    #
    def collection?
      true
    end

    # Get the content length
    #
    # @return [Fixnum] the length
    #
    def content_length
      4096
    end

    # Get the file content type
    #
    # @return [String] the file content type
    #
    def content_type
      'httpd/unix-directory'
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

    # Tests if the resource exist
    #
    # @return [Boolean] the existence status
    #
    def exist?
      true
    end

  end
end
