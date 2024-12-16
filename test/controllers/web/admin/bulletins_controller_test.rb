# frozen_string_literal: true

require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
  end

  test 'should get index when admin' do
    sign_in @admin

    get admin_root_path

    assert_response :success
  end
end
