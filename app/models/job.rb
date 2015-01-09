class Job < ActiveRecord::Base
  belongs_to :job_group
  belongs_to :user
end
