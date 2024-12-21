# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.blank?
        scope.published
      elsif user.admin?
        scope.all
      else
        scope.published_or_created_by(user)
      end
    end
  end

  def new?
    create?
  end

  def create?
    user
  end

  def edit?
    update?
  end

  def update?
    author?
  end

  def to_moderate?
    user.admin? || author?
  end

  def archive?
    user&.admin? || author?
  end

  def publish?
    user&.admin?
  end

  def reject?
    user&.admin?
  end

  private

  def author?
    user && record.user == user
  end
end
