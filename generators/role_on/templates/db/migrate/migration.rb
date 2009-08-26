class SetupRoleOn < ActiveRecord::Migration
  def self.up
    create_table :roles, :force => true do |t|
      t.string :name
      t.timestamps
    end

    add_index :roles, :name

    create_table :user_roles, :id => false, :force => true do |t|
      t.integer :role_id, :user_id
    end

    add_index :user_roles, :role_id
    add_index :user_roles, :user_id

    r = Role.create(:name => 'admin')
  end

  def self.down
    drop_table :roles
    drop_table :roles_users
  end
end
