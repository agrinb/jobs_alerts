class AddTimestampsToJobs < ActiveRecord::Migration
  def change
    add_timestamps :jobs
  end
end
