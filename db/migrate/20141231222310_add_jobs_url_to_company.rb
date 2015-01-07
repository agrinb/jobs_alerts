class AddJobsUrlToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :job_url, :string
  end
end
