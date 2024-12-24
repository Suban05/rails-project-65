# frozen_string_literal: true

class NameIsRequiredInCategories < ActiveRecord::Migration[7.2]
  def change
    change_column_null :categories, :name, true
  end
end
