# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < Web::ApplicationController
      def index
        @bulletins = Bulletin.all
      end

      private

      def set_bulletin
        @bulletin = Bulletin.find(params[:id])
      end
    end
  end
end
