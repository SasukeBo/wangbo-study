class ChangeUsersActivated < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :users do |t|
        dir.up   { t.change :activated, :boolean }
        dir.down { t.change :activated, :boolean, default: false }
      end
    end
  end
end
