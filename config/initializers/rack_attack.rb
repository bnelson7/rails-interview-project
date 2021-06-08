class Rack::Attack

Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 
# cache.store = ActiveSupport::Cache::MemoryStore.new

Rails.cache.write("total_requests", 0, expires_in: 24.hours)
day_limit = Rails.cache.read("total_requests") > 100 ? 1 : 100000000000000000000

throttle('req/ip', limit: 1, period: 10) do |req|
    Rails.cache.increment("total_requests", 1)
    req.ip if req.path == "/questions"
  end

end