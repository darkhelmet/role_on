module RoleOn
  module RoleOnControllerMethods
    def role_on(role, options = {})
      before_filter do |c|
        action = c.params[:action].intern
        user_roles = c.current_user.roles.map(&:name).map(&:intern)
        restricted_actions = if options.include?(:on)
                               [options[:on]].flatten
                             elsif options.include?(:except)
                               c.class.action_methods.to_a.map(&:intern) - [options[:except]].flatten
                             else
                               c.class.action_methods.to_a.map(&:intern)
                             end
        if restricted_actions.include?(action) && !user_roles.include?(role)
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
      (class << self; self; end).class_eval do
        define_method("all_#{name}") do
          User.find(:all, :conditions => [ 'roles.id is ? or roles.id != ?', nil, Role[role].id ], :include => :roles)
        end
      end
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
