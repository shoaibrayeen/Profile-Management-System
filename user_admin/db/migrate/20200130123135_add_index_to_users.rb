class AddIndexToUsers < ActiveRecord::Migration[5.1]
  def change
    #add_index :users, :email
    add_index :users, :created_at
  end
end
