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

  module RoleOnUserMethods
    def has_role?(role)
      return false if roles.nil?
      roles.include?(Role[role])
    end
  end

  def self.included(klass)
    if User == klass
      klass.send(:include, RoleOnUserMethods)
      klass.send(:has_and_belongs_to_many, :roles, :join_table => 'user_roles')
    elsif ApplicationController == klass
      klass.send(:extend, RoleOnControllerMethods)
    end
  end
end
