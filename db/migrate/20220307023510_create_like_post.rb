class CreateLikePost < ActiveRecord::Migration[6.1]
  def change
    create_table :like_posts do |t|
      t.integer :user_id
      t.integer :post_id
    end
  end
end
