class RemoveIndexFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, :email
    remove_index :users, :contact
    remove_index :users, :created_at
  end
end
