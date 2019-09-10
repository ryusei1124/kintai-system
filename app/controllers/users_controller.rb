class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy, :show, :on_duty]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: [:destroy, :edit_basic_info, :update_basic_info, :index, :on_duty]
  before_action :general_user,    only: :show
  before_action :hidden,          only: :show

  def index
    if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
      @q = User.ransack(search_params, activated_true: true)
      @title = "検索結果"
    else
      @q = User.ransack(activated_true: true)
      @title = "ユーザー一覧"
    end
    @users = @q.result.paginate(page: params[:page])
  end
  
  # def import
  #   # fileはtmpに自動で一時保存される
  #   User.import(params[:file])
  #   redirect_to users_url
  # end

  def show
    @user = User.find(params[:id])
    @first_day = first_day(params[:first_day])
    @last_day = @first_day.end_of_month
    (@first_day..@last_day).each do |day|
      unless @user.attendances.any? {|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day)
        record.save
      end
    end
    @dates = user_attendances_month_date
    @worked_sum = @dates.where.not(started_at: nil).count
    respond_to do |format|
      format.html
      format.csv do
        send_data render_to_string, filename: "#{@user.name}.csv", type: :csv
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "#{@user.name}さんを新規作成しました。"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "#{@user.name}さんの情報を更新しました。"
      redirect_to edit_user_url
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "#{@user.name}さんを削除しました。"
    redirect_to users_url
  end
  
  def update_basic_info
    @user = User.find(params[:id])
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}さんの基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name_was}さんの更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def import
    # fileはtmpに自動で一時保存される
    if params[:file].blank?
      flash[:danger] = "インポートするCSVファイルを選択してください。"
      redirect_to users_url
    else
      User.import(params[:file])
      flash[:success] = "ユーザーを追加しました。"
      redirect_to users_url
    end
  end
  
  def on_duty
    @working_users = []
    @working_employee_number = []
    User.all.each do |user|
      if user.attendances.any?{|day|
         ( day.worked_on == Date.today &&
           !day.started_at.blank? &&
           day.finished_at.blank? )}
        @working_users.push(user.name)
        @working_employee_number.push(user.employee_number)
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:name, :email, :affiliation, :uid, :employee_number, :password, :password_confirmation, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
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

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      if !current_user.admin?
        redirect_to(root_url)
        flash[:danger] = "管理者以外アクセスできません。"
      end
    end
    
    #検索機能
    def search_params
      params.require(:q).permit(:name_cont)
    end

    #一般ユーザーで他のユーザーのURLを指定しても開けないようにする
    def general_user
      @user = User.find(params[:id])
      redirect_to(root_url) if !current_user.admin? && !current_user?(@user)
    end
    
    #管理者は勤怠画面の表示禁止
    def hidden
      redirect_to(root_url) if current_user.admin?
    end
end
