class CreatePreferences < ActiveRecord::Migration
  def change
    drop_table :preferences
    create_table :preferences do |t|
      t.string :name
      t.timestamps
    end
  end
end
