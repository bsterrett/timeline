$redis = Redis::Namespace.new(:ns, redis: Redis.new(url: ENV["REDIS_URL"]))
