# frozen_string_literal: true

class Web::ProfilesController < Web::ApplicationController
  before_action :authenticate_user!
  before_action :current_user

  def show
    @q = current_user.bulletins.ransack(params[:q])
    @bulletins = @q.result
                   .order(updated_at: :desc)
                   .page(params[:page])
                   .per(12)
  end
end
