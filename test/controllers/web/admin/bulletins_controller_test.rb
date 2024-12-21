# frozen_string_literal: true

require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @drafted = bulletins(:drafted)
    @under_moderation = bulletins(:under_moderation)
    @published = bulletins(:published)
  end

  test 'gets index when admin' do
    sign_in @admin
    get admin_root_path
    assert_response :success
  end

  test 'publishes bulletin when admin' do
    sign_in @admin
    patch publish_admin_bulletin_url(@under_moderation)
    assert @under_moderation.reload.published?
  end

  test 'rejects bulletin when admin' do
    sign_in @admin
    patch reject_admin_bulletin_url(@under_moderation)
    assert @under_moderation.reload.rejected?
  end

  test 'archives bulletin when admin' do
    sign_in @admin
    patch archive_admin_bulletin_url(@under_moderation)
    assert @under_moderation.reload.archived?
  end

  test 'does not publish drafted bulletin when admin' do
    sign_in @admin
    patch publish_admin_bulletin_url(@drafted)
    assert_redirected_to admin_bulletins_url
  end
end
