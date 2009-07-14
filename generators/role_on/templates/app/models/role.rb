class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => 'user_roles'

  def self.[](role)
    first(:conditions => ['name = ?', role.to_s ])
  end
end
