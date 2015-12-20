class CreateRelatinoships < ActiveRecord::Migration
  def change
    create_table :relatinoships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relatinoships,:follower_id 
    add_index :relatinoships,:followed_id
    add_index :relatinoships,[:followed_id,:follower_id], unique:true
  end
end
