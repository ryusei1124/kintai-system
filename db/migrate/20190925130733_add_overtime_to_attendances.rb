class AddOvertimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :end_overtime, :integer
    add_column :attendances, :business_content, :string
    add_column :attendances, :superior_request, :string
  end
end
