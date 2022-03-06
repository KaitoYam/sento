class User < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.integer :point, default: 0
      t.string :rank, default: 'normal'
    end
  end
end