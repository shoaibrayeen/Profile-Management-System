class CreateTableReport < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.string :date
      t.integer :no_of_profiles

      t.timestamps
    end
  end
end
