# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    can :create, User

    return if user.blank?

    # micropost
    can [:vote,:read], Micropost
    can [:create, :destroy], Micropost, user: user
    can :home, Micropost, ["user_id IN (SELECT followed_id FROM relationships
    WHERE  follower_id = ?) OR user_id = ?", user.id, user.id]
    # user
    can :read, User
    can [:update, :following, :followers], User, id: user.id
    # comment
    can [:vote, :read, :create], Comment
    can [:update, :destroy], Comment, user: user
    can :destroy, Comment, micropost: { user: user}

    return unless user.has_role? :admin

    can :manage, User
  end
end
