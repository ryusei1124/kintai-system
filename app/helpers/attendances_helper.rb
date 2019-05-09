module AttendancesHelper
  def working_times(started_at, finished_at)
    format("%.2f", (((finished_at - started_at) / 60) / 60.0))
  end
end
