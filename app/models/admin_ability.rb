class AdminAbility
  include CanCan::Ability

  def initialize(user)
    if user.present?
      if user.is? :admin
        can :manage, :all
      elsif user.is? :editor
        can :manage, Entry
      elsif user.is? :contributor
        can [:new, :edit], Entry
      end
    end
  end
end
