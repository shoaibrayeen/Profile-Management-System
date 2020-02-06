class RenameTypeInUser < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :type, :user_type
  end
end
