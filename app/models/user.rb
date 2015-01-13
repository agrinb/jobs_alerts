require 'pusher'

Pusher.url = "http://6820c0d85f970bbf1bb7:7cf35e3c19a2f53595d4@api.pusherapp.com/apps/100611"

class User < ActiveRecord::Base
  validates :uid, presence: true
  has_many :companies
  has_many :job_groups
  has_many :jobs


  def self.find_jobs
    jobs = []
    users = User.all
    users.each do |user|
      user.companies.each do |company|
        jobs << company.process_dom_for_jobs
      end
      user.notify_user(user.uid, jobs)
    end
  end

  def notify_user(uid, jobs, status)
    if status
      Pusher["#{uid}"].trigger('jobs_json', jobs.first.to_json)
    else
      Pusher["#{uid}"].trigger('jobs_json', {"status" => "false"}.to_json) 
    end
  end


  def find_my_jobs
    jobs = []
    status = false
    last_job_id = self.jobs.last.id 
    self.companies.each do |company|
      company.process_dom_for_jobs
    end
    new_jobs = Job.where("user_id = ?", id).order(created_at: :desc).take(10)
    jobs << new_jobs
    current_job_id = self.jobs.last.id 
    if current_job_id > last_job_id
      status = true
    end
    self.notify_user(uid, jobs, status)
  end
end
