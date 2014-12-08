class User < ActiveRecord::Base
  has_many :companies
  has_many :job_groups


  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.avatar = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def self.find_jobs
    users = User.all
    users.each do |user|
      Company.user_links(user)
    end
  end

  def self.notify_all
    binding.pry

end
