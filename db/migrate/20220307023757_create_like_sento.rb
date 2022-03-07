class CreateLikeSento < ActiveRecord::Migration[6.1]
  def change
    create_table :like_sentos do |t|
      t.integer :user_id
      t.integer :sento_id
    end
  end
end
