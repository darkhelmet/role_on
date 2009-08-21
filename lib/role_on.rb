module RoleOn
  module RoleOnControllerMethods
    def role_on(role, options = {})
      before_filter do |c|
        options = c.__send__(:role_on_defaults).merge(options) if (c.methods | c.protected_methods | c.private_methods).include?('role_on_defaults')
        action = c.params[:action].intern
        user_roles = c.__send__(:current_user).roles.map(&:name).map(&:intern)
        restricted_actions = if options.include?(:on)
                               [options[:on]].flatten
                             elsif options.include?(:except)
                               c.class.action_methods.to_a.map(&:intern) - [options[:except]].flatten
                             else
                               c.class.action_methods.to_a.map(&:intern)
                             end
        if restricted_actions.include?(action) && !user_roles.include?(role) && (options.include?(:sa) ? !user_roles.include?(options[:sa]) : false)
          c.__send__(:access_denied)
          false
        else
          true
        end
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
      named_scope(name, lambda { { :conditions => ['roles.id = ?', Role[role].id], :joins => :roles } })
      named_scope("non_#{name}", lambda { { :conditions => [ 'roles.id is ? or roles.id != ?', nil, Role[role].id ], :include => :roles } })
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
