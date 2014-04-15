class Changegender < ActiveRecord::Migration
  def up
    change_column :users, :gender, :string
  end

  def down
    change_column :users, :gender, :boolean
  end
end
