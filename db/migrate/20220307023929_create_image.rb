class CreateImage < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.integer :sento_id
      t.integer :post_id
      t.integer :user_id
      t.string :url
    end
  end
end
