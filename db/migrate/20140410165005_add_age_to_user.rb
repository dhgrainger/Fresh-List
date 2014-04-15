class AddAgeToUser < ActiveRecord::Migration
  def up
    add_column :users, :age, :integer, null: false
  end

  def down
    remove_column :users, :age
  end
end

