class Createportfoliotable < ActiveRecord::Migration
  def up
  	create_table :portfolios do |n|
  		n.integer :user_id
  		n.string :name
  		n.datetime :created_at
  end
end

  def down
  	drop_table :portfolios
  end
end
