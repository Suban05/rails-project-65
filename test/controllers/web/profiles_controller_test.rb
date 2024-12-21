# frozen_string_literal: true

class Web::ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'gets show' do
    sign_in @user
    get profile_path
    assert_response :success
  end

  test 'gets index when user is logged in' do
    sign_in(@user)
    get profile_path

    assert_response :success
  end
end
