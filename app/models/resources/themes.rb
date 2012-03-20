module Resources

  # The theme directory that contains all installed themes.
  #
  class Themes < ::Shopidav::Resources::Folder

    def name
      'themes'
    end

    def public_path
      '/themes'
    end

    def children
      ::ShopifyAPI::Theme.find(:all).inject([]) do |result, theme|
        result << ::Resources::Theme.new(public_path, path, request, response, options)
      end
    end

    def creation_date
      Date.new
    end

    def last_modified
      Date.new
    end

  end

end

