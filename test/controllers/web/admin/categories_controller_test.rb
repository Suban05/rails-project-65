# frozen_string_literal: true

require 'test_helper'

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:one)
    @admin = users(:admin)
    @empty = categories(:empty)
  end

  test 'should get index when admin' do
    sign_in @admin

    get admin_categories_url

    assert_response :success
  end

  test 'should get new when admin' do
    sign_in @admin

    get new_admin_category_url

    assert_response :success
  end

  test 'should create category when admin' do
    sign_in @admin

    post admin_categories_url, params: { category: { name: 'New category' } }
    assert Category.exists?(name: 'New category')
  end

  test 'should get edit when admin' do
    sign_in @admin

    get edit_admin_category_path(@category)

    assert_response :success
  end

  test 'should update category when admin' do
    sign_in @admin

    patch admin_category_url(@category), params: { category: { name: 'New category' } }
    assert_equal('New category', @category.reload.name)
  end

  test 'should not delete not empty category when admin' do
    sign_in users(:admin)

    assert_no_difference('Category.count') do
      delete admin_category_url(@category)
    end

    assert Category.exists?(@category.id)
    assert_redirected_to admin_categories_path
  end

  test 'should delete empty category when admin' do
    sign_in @admin

    delete admin_category_url(@empty)
    assert_not Category.exists?(@empty.id)
  end
end
