class AddJobGroupIdToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :job_group_id, :integer
  	remove_column :job_groups, :job_id
  end
end
