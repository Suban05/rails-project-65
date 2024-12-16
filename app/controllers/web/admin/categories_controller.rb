# frozen_string_literal: true

class Web::Admin::CategoriesController < Web::ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = Category.order(name: :asc).all
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.create(category_params)

    if @category.save
      redirect_to admin_categories_path, notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.bulletins.exists?
      redirect_to admin_categories_path, alert: t('.cannot_delete')
    else
      @category.destroy
      redirect_to admin_categories_path, notice: t('.success')
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find params[:id]
  end
end
