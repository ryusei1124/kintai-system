class AttendancesController < ApplicationController
  before_action :logged_in_user,  only: :edit
  before_action :general_user, only: :edit
  
  
  def create
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find_by(worked_on: Date.today)
    if @attendance.started_at.nil?
      @attendance.update_attributes(started_at: current_time)
      flash[:info] = 'おはようございます。'
    elsif @attendance.finished_at.nil?
      @attendance.update_attributes(finished_at: current_time)
      flash[:info] = 'おつかれさまでした。'
    else
      flash[:danger] = 'トラブルがあり、登録出来ませんでした。'
    end
    redirect_to @user
  end
  
  def edit
    @user = User.find(params[:id])
    @first_day = first_day(params[:date])
    @last_day = @first_day.end_of_month
    @dates = user_attendances_month_date
  end
  
  def update
    @user = User.find(params[:id])
    if attendances_invalid?
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes(item)
      end
      flash[:success] = '勤怠情報を更新しました。'
      redirect_to user_path(@user, params:{first_day: params[:date]})
    else
      redirect_to edit_attendances_path(@user, params[:date])
    end
  end
  
  private
    def attendances_params
      params.permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
    
    # ログインしていない一般ユーザーは勤怠編集画面を開けない
    def general_user
      @user = User.find(params[:id])
      redirect_to(root_url) if !current_user.admin? && !current_user?(@user)
    end
    
    # ログイン済みユーザーか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
end
