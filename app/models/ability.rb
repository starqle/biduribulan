class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    
    if user.present? && user.is?(:admin)
      can :manage, :all
    end

  end
end
