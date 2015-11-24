class Lobby
  class << self
    def add_user_to_lobby user
      return if redis.sismember('user-ids', user.id)

      proxy_username = get_unique_proxy_username user

      redis.hmset("user:#{user.id}",
        :id, user.id,
        :username, user.username,
        :proxy_username, proxy_username,
        :color, user.color,
        :updated, Time.now.to_i
      )
      redis.expire("user:#{user.id}", 10.minute.to_i)

      redis.sadd('user-ids', user.id)
      redis.expire('user-ids', 10.minute.to_i)

      unless redis.sismember('ready-user-ids', user.id)
        set_user_unready user
      end
    end

    def get_unique_proxy_username user
      current_proxy_usernames = redis.smembers('user-ids').map do |user_id|
        redis.hget("user:#{user_id}", :proxy_username)
      end

      count = 0
      proxy_username = user.username

      while current_proxy_usernames.include? proxy_username
        count += 1
        proxy_username = "#{user.username} (#{count})"
      end

    proxy_username
    end

    def remove_users_from_lobby users
      users.each { |user| remove_user_from_lobby user }
    end

    def remove_user_from_lobby user
      redis.del "user:#{user.id}"

      redis.srem('user-ids', user.id)
      redis.srem('ready-user-ids', user.id)
      redis.srem('unready-user-ids', user.id)
    end

    def set_user_ready user
      redis.sadd('ready-user-ids', user.id)
      redis.expire('ready-user-ids', 10.minute.to_i)
      redis.srem('unready-user-ids', user.id)
    end

    def set_user_unready user
      redis.srem('ready-user-ids', user.id)
      redis.sadd('unready-user-ids', user.id)
      redis.expire('unready-user-ids', 10.minute.to_i)
    end

    def get_ready_users
      user_ids = redis.smembers('ready-user-ids')
      users = user_ids.map do |id|
        redis.hgetall("user:#{id}").symbolize_keys
      end
    end

    def get_unready_users
      user_ids = redis.smembers('unready-user-ids')
      users = user_ids.map do |id|
        redis.hgetall("user:#{id}").symbolize_keys
      end
    end

    def redis
      return @redis if @redis

      if $redis
        @redis = Redis::Namespace.new(:lobby, redis: $redis)
      else
        @redis = Redis::Namespace.new(:lobby, redis: Redis.new(url: ENV["REDIS_URL"]))
      end
    end
  end
end