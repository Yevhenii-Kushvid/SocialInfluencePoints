class CreateFriendLists < ActiveRecord::Migration
  def change
    create_table :friend_lists do |t|
      t.integer :friend_of_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
