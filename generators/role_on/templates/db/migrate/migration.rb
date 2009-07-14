class SetupRoleOn < ActiveRecord::Migration
  def self.up
    create_table :roles, :force => true do |t|
      t.string :name
      t.timestamps
    end

    add_index :roles, ['name'], :name => 'index_roles_on_name'

    create_table :user_roles, :id => false, :force => true do |t|
      t.integer :role_id, :user_id
    end

    r = Role.create(:name => 'admin')
  end

  def self.down
    drop_table :roles
    drop_table :roles_users
  end
end
