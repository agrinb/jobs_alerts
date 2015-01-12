require 'pusher'

Pusher.url = "http://6820c0d85f970bbf1bb7:7cf35e3c19a2f53595d4@api.pusherapp.com/apps/100611"

class User < ActiveRecord::Base
  validates :uid, presence: true
  has_many :companies
  has_many :job_groups
  has_many :jobs


  # def self.from_omniauth(auth)
  #   puts auth
  #   where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
  #     user.provider = auth.provider
  #     user.uid = auth.uid
  #     user.email = auth.info.email
  #     user.first_name = auth.info.first_name
  #     user.last_name = auth.info.last_name
  #     user.avatar = auth.info.image
  #     user.oauth_token = auth.credentials.token
  #     user.oauth_expires_at = Time.at(auth.credentials.expires_at)
  #     user.save!
  #   end
  # end

  # def create
  #   @user = User.create(uid: )
  # end

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
      jobs << company.process_dom_for_jobs
    end
    current_job_id = self.jobs.last.id 
    if current_job_id > last_job_id
      status = true
    end
    self.notify_user(uid, jobs, status)
  end
end
