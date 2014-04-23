class AddUserIdToPreferences < ActiveRecord::Migration
  def up
    add_column :preferences, :user_id, :integer
  end

  def down
    remove_column :preferences, :user_id
  end
end
