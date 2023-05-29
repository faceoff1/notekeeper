class AddNameAndFullnameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :fullname, :string
  end
end
