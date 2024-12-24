# frozen_string_literal: true

class AllUsersAreAdmins < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :admin, from: nil, to: true
    change_column_null :users, :admin, false
  end
end
