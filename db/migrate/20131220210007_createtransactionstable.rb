class Createtransactionstable < ActiveRecord::Migration
  def up
  	create_table :transactions do |n|
  		n.integer :portfolio_id
  		n.string :symbol
  		n.integer :type
  		n.integer :price
  		n.integer :shares
  		n.timestamp :created_at
  end
end

  def down
  	drop_table :transactions
  end
end
