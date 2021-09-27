class Public::ListsController < ApplicationController
    before_action :authenticate_user!
    before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def new

  end

  def index
    @lists = List.where(user_id:current_user.id)
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    if @list.save
      flash[:notice] = "投稿に成功しました"
      redirect_to lists_path
    else
      @lists = List.where(user_id:current_user.id)
      flash[:alert] = "投稿に失敗しました"
      render 'index'
    end
  end

  def edit
    @list = List.find(params[:id])
  end

  def show
    @list = List.find(params[:id])
    @spots = @list.spots
  end

  def update
    @list = List.find(params[:id])
    if @list.update(list_params)
      flash[:notice] = "保存に成功しました"
      redirect_to list_path(@list)
    else
      flash[:alert] = "保存に失敗しました"
      render 'edit'
    end
  end

  def destroy
    @list_destroy = List.find(params[:id])
    @list = List.new
    @lists = List.where(user_id:current_user.id)
    if @list_destroy.destroy
      flash[:notice] = "削除に成功しました"
      redirect_to lists_path
    else
      flash[:alert] = "削除に失敗しました"
      render 'index'
    end
  end

  private

  def list_params
    params.require(:list).permit(:name).merge(user_id:current_user.id)
  end

  def correct_user
    @list = List.find(params[:id])
    if @list.user.id != current_user.id
      flash[:alert] = "このURLは無効です"
      redirect_to root_path
    end
  end
end
