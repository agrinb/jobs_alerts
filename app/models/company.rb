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
  

  def find_links
    jobs_array = []
    last_fetch = Nokogiri::HTML(open(self.url))
    a_nodes = last_fetch.css("a")
    kwords.each do |keyword|
      a_nodes.children.each_with_index do |node, i|
       if node.text.include?(keyword)
          binding.pry
          job_url = process_url(node.parent['href'])   
          binding.pry
          job = Job.find_or_initialize_by(url: job_url, title: node.text)
          
          job.update_attributes(job_group_id: job_group.id, company_id: self.id)
          job.save!
          jobs_array << job
        end
      end
    end
    process_jobs(links)
  end

  def process_url(link)
    source_type
    if source_type = "craigslist"
      process_cl_url(link)
    else 
      process_other_urls
    end
  end


  def source_type
    if self.url.include?('craigslist.org/search')
      "craigslist"
    else
      "not craigslist"
    end
  end

  def process_cl_url(link)
    base_url = url.split('/search').first
    node_url = link
    binding.pry
    mod_url = base_url << node_url
  end


  #  def process_jobs(jobs_array)
  #   if self.url.include?('craigslist.org/search')
  #     process_cl_urls(jobs_array)
  #   else
  #     process_other_urls(company)
  #   end
  # end

  def process_other_urls(url)
  end

  def process_cl_urls(jobs_array)
    processed_jobs = []
    jobs_array.each do |job|
      unless job.values.include?('http://')
        base_url = url.split('/search').first
        mod_url = base_url << job.values.first
        modified_job = { job.keys.first => mod_url }
      end
      processed_jobs << modified_job
    end
    processed_jobs
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
