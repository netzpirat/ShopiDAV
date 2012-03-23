# The prefetch worker requests data from
# the Shopify API and stores it locally in Redis.
#
class PrefetchWorker
  include Sidekiq::Worker

  def perform(api)
  end

end
