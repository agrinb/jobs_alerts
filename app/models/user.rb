require 'pusher'

Pusher.url = "http://6820c0d85f970bbf1bb7:7cf35e3c19a2f53595d4@api.pusherapp.com/apps/100611"

class User < ActiveRecord::Base
  has_many :companies
  has_many :job_groups


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
      notify_user(user.id, jobs)
    end
  end

  def self.notify_user(user_id, jobs)
    Pusher["#{user_id}"].trigger('my_event', jobs.first.to_json)
  end

end
