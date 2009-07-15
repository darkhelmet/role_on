# role_on

Really Simple Roles

# Assumptions

I assume you have a model called User for your user authentication stuff.

# Usage

    config.gem 'darkhelmet-role_on', :lib => 'role_on', :source => 'http://gems.github.com'

Add

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def access_denied
      flash[:error] = 'You are not authorized to perform this action'
      redirect_back_or_default '/'
    end

Or similar to you application controller, and setup store_location as an after_fitler, and all of them as helper methods

    after_filter :store_location
    helper_method :store_location, :redirect_back_or_default, :access_denied

Include RoleOn in your application controller and User model

    include RoleOn

Generate model and migration

    ./script/generate role_on

Migrate

    rake db:migrate

Do your own thing for managing roles.

Start locking down your controllers

    role_on(:admin, :on => [:new,:create,:destroy])
    role_on(:regular, :on => [:edit,:update])

Add your views

    if current_user.has_role?(:admin) # do stuff

Can also use except

    role_on(:admin, :except => [:index,:show])

# License

See LICENSE for details.
