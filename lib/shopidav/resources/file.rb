module Shopidav
  module Resources

    # Base class for API resources that can be accessed
    # as file resource.
    #
    class File < ::Shopidav::Resources::Shopify

      def collection?
        false
      end

    end

  end
end
