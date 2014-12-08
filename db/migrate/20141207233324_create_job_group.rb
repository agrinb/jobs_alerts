class CreateJobGroup < ActiveRecord::Migration
  def change
    create_table :job_groups do |t|
    	t.integer :job_id
    	t.integer :user_id
    end
  end
end
