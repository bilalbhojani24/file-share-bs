class AddFieldnameToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string
    add_index :users, :username
    add_column :users, :name, :string
  end
end
