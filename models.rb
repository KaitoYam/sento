require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
    validates :password,
        length: {in: 5..15}
end

class Sento < ActiveRecord::Base
end

class Post < ActiveRecord::Base
end

class Image < ActiveRecord::Base
end

class Movie < ActiveRecord::Base
end

class LikeSento < ActiveRecord::Base
end

class LikePost < ActiveRecord::Base
end