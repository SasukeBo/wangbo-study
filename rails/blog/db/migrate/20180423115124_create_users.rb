class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nick_name
      t.string :username
      t.string :password_digest
      t.string :email
      t.string :phone_num
      t.integer :sex
    end
  end
end
