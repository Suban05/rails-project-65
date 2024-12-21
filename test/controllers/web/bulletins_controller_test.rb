# frozen_string_literal: true

require 'test_helper'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @published = bulletins(:published)
    @drafted = bulletins(:drafted)
    @user = users(:one)
    @attrs = {
      bulletin: {
        title: 'New title',
        description: 'New description',
        image: fixture_file_upload('bulletin1.jpg', 'image/jpg'),
        category_id: Category.last.id
      }
    }
  end

  test 'gets index' do
    get root_path
    assert_response :success
  end

  test 'gets show' do
    get bulletin_url(@published)
    assert_response :success
  end

  test 'does not get show when bulletin is drafted from other user' do
    sign_in users(:two)
    get bulletin_url(@drafted)
    assert_response :not_found
  end

  test 'gets new for logged in user' do
    sign_in @user
    get new_bulletin_url
    assert_response :success
  end

  test 'does not get new for not logged in user' do
    get new_bulletin_url
    assert_redirected_to root_url
  end

  test 'creates bulletin for logged in user' do
    sign_in @user
    assert_difference('Bulletin.count') do
      post bulletins_path, params: @attrs
    end
    assert_redirected_to profile_path
    assert Bulletin.find_by(title: @attrs[:bulletin][:title])
  end

  test 'does not create bulletin for not logged_in user' do
    assert_no_difference('Bulletin.count') do
      post bulletins_path, params: @attrs
    end

    assert_redirected_to root_path
  end

  test 'gets edit for logged in user' do
    sign_in @user
    @published.update(user: @user)
    get edit_bulletin_url(@published)
    assert_redirected_to profile_url
  end

  test 'does not get edit for not author' do
    sign_in(users(:two))
    get edit_bulletin_url(@published)
    assert_redirected_to root_url
  end

  test 'does not update bulletin for not author' do
    sign_in users(:two)
    bulletin = bulletins(:one)

    original_title = bulletin.title
    original_description = bulletin.description

    patch bulletin_path(bulletin), params: @attrs

    bulletin.reload
    assert_equal original_title, bulletin.title
    assert_equal original_description, bulletin.description
    assert_redirected_to root_path
  end

  test 'moves to moderate for author' do
    sign_in @user
    patch to_moderate_bulletin_url(@drafted)
    assert_redirected_to profile_url
    assert @drafted.reload.under_moderation?
  end

  test 'does not move to moderate for not author' do
    sign_in users(:two)
    patch to_moderate_bulletin_path(@drafted)
    assert_redirected_to root_path
    assert_not @drafted.reload.under_moderation?
  end

  test 'updates bulletin for author' do
    sign_in @user
    @drafted.update(user: @user)

    patch bulletin_url(@drafted), params: { bulletin: { title: 'New title', description: 'The best description' } }

    assert_redirected_to profile_url
    @drafted.reload

    assert_equal 'New title', @drafted.title
    assert_equal 'The best description', @drafted.description
  end

  test 'does not move to archive for not author' do
    sign_in users(:two)
    patch archive_bulletin_path(@published)
    assert_redirected_to root_path
    assert_not @published.reload.archived?
  end
end
