module RoleOn
  module RoleOnControllerMethods
    def role_on(role, options = {})
      before_filter do |c|
        if c.respond_to?(:role_on_defaults)
          options = c.role_on_defaults.merge(options)
        end
        action = c.params[:action].intern
        user_roles = c.current_user.roles.map(&:name).map(&:intern)
        restricted_actions = if options.include?(:on)
                               [options[:on]].flatten
                             elsif options.include?(:except)
                               c.class.action_methods.to_a.map(&:intern) - [options[:except]].flatten
                             else
                               c.class.action_methods.to_a.map(&:intern)
                             end
        if restricted_actions.include?(action) && !user_roles.include?(role) && (options.include?(:sa) ? !user_roles.include?(options[:sa]) : false)
          c.send(:access_denied)
          false
        end
        true
      end
    end
  end

  module RoleOnUserInstanceMethods
    def has_role?(*roles)
      return false if self.roles.empty?
      roles.reject { |r| self.roles.include?(Role[r]) }.empty?
    end
    alias :has_roles? :has_role?
  end

  module RoleOnUserClassMethods
    def helper_for(role,name = role.to_s.pluralize)
      named_scope(name, :conditions => ['role_id = ?', Role[role].id], :joins => :roles)
      named_scope("non_#{name}", :conditions => [ 'roles.id is ? or roles.id != ?', nil, Role[role].id ], :joins => :roles)
    end
  end

  def self.included(klass)
    if User == klass
      klass.send(:include, RoleOnUserInstanceMethods)
      klass.send(:extend, RoleOnUserClassMethods)
      klass.send(:has_and_belongs_to_many, :roles, :join_table => 'user_roles')
    elsif ApplicationController == klass
      klass.send(:extend, RoleOnControllerMethods)
    end
  end
end
