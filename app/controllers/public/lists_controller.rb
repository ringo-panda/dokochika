class Public::ListsController < ApplicationController
    before_action :authenticate_user!
    before_action :correct_user, only: [:show, :edit, :update, :destroy]


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
  end

  def update
    @list = List.find(params[:id])
    if @list.update(list_params)
      flash[:notice] = "保存に成功しました"
      redirect_to list_path(@list)
    else
      flash[:alert] = "保存に失敗しました"
      render 'show'
    end
  end

  def destroy
    @list = List.new
    @lists = List.where(user_id:current_user.id)
    delete_list = List.find(params[:id])
    delete_spots = delete_list.spots
    delete_spots.each do |spot|
      list_spot = ListSpot.find_by(user_id:current_user.id, spot_id:spot.id, list_id:delete_list.id)
      if list_spot.present?
        list_spot.destroy
      end
      if spot.lists.length == 0
        spot.destroy
      end
    end
    delete_list.destroy
    flash[:notice] = "削除に成功しました"
    redirect_to lists_path
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
