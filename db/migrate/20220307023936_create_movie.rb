class CreateMovie < ActiveRecord::Migration[6.1]
  def change
    create_table :moives do |t|
      t.integer :sento_id
      t.integer :post_id
      t.integer :user_id
      t.string :url
    end
  end
end
