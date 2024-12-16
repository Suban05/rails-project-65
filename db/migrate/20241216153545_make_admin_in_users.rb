# frozen_string_literal: true

class MakeAdminInUsers < ActiveRecord::Migration[7.2]
  def change
    user = User.find_by(email: 'anatolyb94@gmail.com')
    user&.update(admin: true)
  end
end
