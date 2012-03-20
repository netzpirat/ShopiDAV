module Resources

  # A theme that has been installed in a Shopify shop.
  #
  class Theme < ::Shopidav::Resources::Folder
    def name
      'Kid'
    end
  end

end
