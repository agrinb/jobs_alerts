require 'open-uri'

class Company < ActiveRecord::Base
  validates :uid, presence: true
  validates :user_id, presence: true
  validates :url, presence: true
  validates :keywords, presence: true
  serialize :keywords
  belongs_to :user
  has_many :jobs, dependent: :destroy


  def kwords 
    kwords = []
    keywords.each do |k|
      kwords << k.downcase
      kwords << k.capitalize
    end
    kwords
  end 
  

  def find_links(job_group)
    links = []
    last_fetch = Nokogiri::HTML(open(self.url))
    a_nodes = last_fetch.css("a")
    kwords.each do |keyword|
      a_nodes.children.each_with_index do |node|
       if node.text.include?(keyword)
          binding.pry
          job = Job.find_or_initialize_by(url: node['href'], title: node.text)
          job.update_attributes(job_group_id: job_group.id, company_id: self.id)
          job.save!
          links << job
        end
      end
    end
    links
  end

  def self.user_links(user)
    links = []
    job_group = JobGroup.create(user_id: user.id)
    user.companies.each do |c|
      c.find_links(job_group)
    end
    User.notify_all
  end


  
    # users = User.all
    # companies = users.map { |user| user.companies }
    # user_jobs = []
    # companies[0].each do |company|
    #   keywords = company.keywords
    #   doc = Nokogiri::HTML(open(company.url))
    #   a_nodes = doc.css("a")
    #   kwords = []
    #   keywords.each do |k|
    #      kwords << k.downcase
    #      kwords << k.capitalize
    #   end
    #   kwords.each do |keyword|
    #     a_nodes.each do |node|
    #       if node.text.include?(keyword) && not_in_last_fetch(company, node)
    #      # if node.text.include?(keyword)

    #       end
    #     end
    #   end
    #   company.last_fetch = Nokogiri::HTML(open(company.url)).to_s
    #   company.save
    # end
    # binding.pry
    # user_jobs
    # end

end
