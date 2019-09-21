module AttendancesHelper
  def current_time
    Time.new(
      Time.now.year,
      Time.now.month,
      Time.now.day,
      Time.now.hour,
      Time.now.min, 0
    )
  end
  
  def working_times(attendance)
    unless attendance.tomorrow?
      format("%.2f", (((attendance.finished_at - attendance.started_at) / 60) / 60.0))
    else
      format("%.2f", (((attendance.finished_at - attendance.started_at) / 60) / 60.0) + 24) 
    end
  end
  # def working_times(started_at, finished_at)
  #   if params[:tomorrow] == "false"
  #     format("%.2f", (((finished_at - started_at) / 60) / 60.0))
  #   else
  #     format("%.2f", (((finished_at - started_at) / 60) / 60.0) + 24) 
  #   end
  # end
  
  def working_times_sum(seconds)
    format("%.2f", seconds / 60 / 60.0)
  end
  
  def first_day(date)
    !date.nil? ? Date.parse(date) : Date.current.beginning_of_month
  end

  def user_attendances_month_date
    @user.attendances.where('worked_on >= ? and worked_on <= ?', @first_day, @last_day).order('worked_on')
  end
  
  def attendances_invalid?
    attendances = true
    attendances_params.each do |id, item|
      if item[:started_at].blank? && item[:finished_at].blank?
        next
      elsif item[:started_at].blank? || item[:finished_at].blank?
        attendances = false
        flash[:danger] = "出社時間または退社時間を入力してください。"
        break
      elsif item[:started_at] > item[:finished_at]
        attendances = false
        flash[:danger] = "出社時間を退社時間より遅い時間に設定することはできません。"
        break
      end
    end
    return attendances
  end
end
