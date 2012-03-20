module Resources

  # The Shop resource is the root node of all resources
  # that are available through WebDAV.
  #
  class Shop < ::Shopidav::Resources::Folder

    def name
      current_api_shop.name
    end

    def children
      [
          ::Resources::Themes.new('/themes', '/themes', request, response, options)
      ]
    end

    def creation_date
      Date.parse(current_api_shop.created_at)
    end

    def last_modified
      current_shop.updated_at
    end
  end

end
