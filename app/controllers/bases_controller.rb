class BasesController < ApplicationController
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy, :new]
  before_action :admin_user,      only: [:destroy, :index, :new]
  
  def index
    @bases = Base.all
  end
  
  def new
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = "拠点情報を追加しました。"
    else
      flash[:danger] = @base.errors.full_messages.join("<br>")
    end
    redirect_to bases_url
  end
  
  def destroy
    @base = Base.find(params[:id]).destroy
    flash[:success] = "拠点情報を削除しました。"
    redirect_to bases_url
  end
  
  def edit
    @base = Base.find(params[:id])
  end

  def update
    @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
      flash[:success] = "拠点情報を更新しました。"
    else
      flash[:danger] = @base.errors.full_messages.join("<br>")
    end
    redirect_to bases_url
  end
  
  private

    def base_params
      params.require(:base).permit(:base_number, :base_name, :base_category)
    end
    
    # beforeアクション

    # ログイン済みユーザーか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # 管理者かどうか確認
    def admin_user
      if !current_user.admin?
        redirect_to(root_url)
        flash[:danger] = "管理者以外アクセスできません。"
      end
    end
end
