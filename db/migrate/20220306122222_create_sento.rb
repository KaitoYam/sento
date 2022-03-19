class CreateSento < ActiveRecord::Migration[6.1]
  def change
    create_table :sentos do |t|
      t.integer :user_id
      t.string :name
      t.string :osusume
      t.string :homepage_url
      t.string :place_id
      t.string :img_url
      t.string :cost
    end
  end
end
