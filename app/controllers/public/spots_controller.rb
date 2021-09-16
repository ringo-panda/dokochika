class Public::SpotsController < ApplicationController
    before_action :authenticate_user!
    before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def new
    @lists = List.where(user_id:current_user.id)
    @list = List.new
  end

  def index
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def show
  end

  private
  def correct_user
    @spot = Spot.find(params[:id])
    if @spot.user.id != current_user.id
      flash[:alert] = "このURLは無効です"
      redirect_to root_path
    end
  end

end
