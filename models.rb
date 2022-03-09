require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
    validates :password,
        length: {in: 5..15}
    has_many :posts
    has_many :likeposts
    has_many :like_sentos
    has_many :favorite_posts, :through => :like_posts, :source => :post
    has_many :sentos
    has_many :favorite_sentos, :through => :like_sentos, :source => :sento
    has_many :images, :through => :post
    has_many :movies, :through => :post
end

class Sento < ActiveRecord::Base
    belongs_to :user
    has_many :images
    has_many :movies
    has_many :posts
    has_many :like_sentos
    has_many :like_users, :through => :like_sentos, :source => :user
end

class Post < ActiveRecord::Base
    belongs_to :user
    belongs_to :sento
    has_many :like_posts
    has_many :like_users, :through => :like_posts, :source => :user
    has_many :images
    has_many :movies
end

class Image < ActiveRecord::Base
    belongs_to :sento
    belongs_to :post
    belongs_to :user
end

class Movie < ActiveRecord::Base
    belongs_to :sento
    belongs_to :post
    belongs_to :user
end

class LikeSento < ActiveRecord::Base
    belongs_to :user
    belongs_to :sento
end

class LikePost < ActiveRecord::Base
    belongs_to :user
    belongs_to :post
end