class AddTokenAndSecretToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :token, :string
    add_column :users, :secret, :string
  end

  def self.down
    remove_column :users, :secret
    remove_column :users, :token
  end
end
