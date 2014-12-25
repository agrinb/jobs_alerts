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
  

  def extract_jobs
    jobs_array = []
    last_fetch = Nokogiri::HTML(open(self.url))
    a_nodes = last_fetch.css("a")
    kwords.each do |keyword|
      a_nodes.children.each_with_index do |node, i|
       if node.text.include?(keyword)
          job = get_job(node)
          jobs_array << job
        end
      end
    end
    jobs_array
  end

  def process_url(link)
    source_type
    if source_type == "craigslist"
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
    mod_url = base_url << node_url
  end

  def get_job(node)
    job_url = process_url(node.parent['href'])   
    check_existing_jobs = Job.where("url = ? AND created_at >= ?", job_url, Time.now - 1.week)
    unless check_existing_jobs.any?
      job = Job.create(url: job_url, title: node.text, company_id: id)
    else 
      check_existing_jobs.first
    end
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
end
