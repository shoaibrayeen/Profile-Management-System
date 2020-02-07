class RenamePasswordColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :password_digest, :password
  end
end
