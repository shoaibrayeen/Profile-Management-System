class AddIndexToAdmin < ActiveRecord::Migration[5.1]
  def change
    add_index :admins, :username
  end
end
