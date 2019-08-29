class RenameDepartmentColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :department, :affiliation
    rename_column :users, :basic_time, :basic_work_time
    rename_column :users, :work_time, :designated_work_start_time
    rename_column :users, :work_end_time, :designated_work_end_time
  end
end
