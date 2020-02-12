class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :contact
      t.string :type
      t.string :password_digest
      t.string :parent_id
      t.string :status

      t.timestamps
    end
  end
end
