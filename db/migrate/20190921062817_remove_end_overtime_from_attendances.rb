class RemoveEndOvertimeFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :end_overtime, :integer
    remove_column :attendances, :business_content, :string
    remove_column :attendances, :superior_request, :string
  end
end
