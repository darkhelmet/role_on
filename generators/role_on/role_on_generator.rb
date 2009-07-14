class RoleOnGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.template 'app/models/role.rb', 'app/models/role.rb'
      m.migration_template 'db/migrate/migration.rb', 'db/migrate', :migration_file_name => 'setup_role_on'
    end
  end
end
