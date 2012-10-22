class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #


    ### TODO: do like case
      user ||= User.new # guest user (not logged in)
      # case user.role.name.to_sym
      # when :admin
      #   can :manage, :all
      # when :employer
      #   can :read, :all
      # when :employee
      #   can :read, :all
      # else
      # end        
        
      if user.role? (:admin)
        can :manage, :all
      elsif user.role? (:employee) # who want to find job

        can :manage, :resume
        can :create, Training
        can :create, Grant
        can :create, Event
        can :read, :all  
        can :update, :training, :owner => user.id
        can :update, :event, :owner => user.id
        can :update, :grant, :owner => user.id
      
      elsif user.role? (:empolyer) # who can create vacancy 
        can :manage, :compinfo
        can :read, :all
        can :create, Training
        can :create, Event
        can :create, Grant
         #can :read, :role
        can :update, :training, :owner => user.id
        can :update, :event, :owner => user.id
        can :update, :grant, :owner => user.id
         #can :read, User, User.juristic do |u|
         # u.role == :juristic || u.id == user.id
         #end 
      else
        can :read, :all
        can :create, Training
        can :create, Event
        can :create, Grant

      end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
