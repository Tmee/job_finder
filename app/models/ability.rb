class Ability
  include CanCan::Ability

  def initialize(user)
      user ||= User.new
      can :manage, Note, :user_id => user.id
      can :manage, User, :id => user.id
  end
end