class CreatePost < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :comment
      t.integer :sento_id
      t.integer :user_id
    end
  end
end
