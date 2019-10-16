class ChangeEndOvertimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    change_column :attendances, :end_overtime, :datetime
  end
end
