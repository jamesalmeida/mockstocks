class Createusertable < ActiveRecord::Migration
  def up
  	create_table :users do |n|
  		n.string :fname
  		n.string :lname
  		n.string :email
  		n.string :username
  		n.string :password_hash
  		n.string :password_salt
  		n.datetime :created_at
  		n.integer :balance
  end
 end

  def down
  	drop_table :users
  end
end
