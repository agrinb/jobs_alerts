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
  

  def process_dom_for_jobs
    jobs_array = []
    begin
    dom = Nokogiri::HTML(open(self.url))
    rescue Errno::ENOENT => e
      $stderr.puts "Caught the exception: #{e}"
    rescue OpenURI::HTTPError => e
      $stderr.puts "Caught the exception: #{e}"
    end
    unless !dom
      a_nodes = dom.css("a")
      kwords.each do |keyword|
        a_nodes.children.each do |node|
         if node.text.include?(keyword)
            job = get_job(node)
            jobs_array << job
          end
        end
      end
    end
    jobs_array
  end



  def process_url(url)
    if source_type == "craigslist"
      process_cl_url(url)
    else 
      process_other_url(url)
    end
  end


  def source_type
    if self.url.include?('craigslist.org/search') || self.url.include?('linkedin')
      "craigslist"
    else
      "not craigslist"
    end
  end

  def process_cl_url(path)
    base_url = extract_domain(url)
    #node_url = link
    mod_url = base_url << path
  end

  def get_job(node)    
    job_url = process_url(node.parent['href'])   
    check_existing_jobs = Job.where("url = ? AND created_at >= ?", job_url, Time.now - 1.week)
    unless check_existing_jobs.any?
      job = Job.create(url: job_url, title: node.text, company_id: id, user_id: self.user_id)
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


  def extract_domain(url)
    uri = URI.parse(url)
    uri = URI.parse("http://#{url}") if uri.scheme.nil?
    uri.scheme + "://" + uri.host
  end


  def process_other_url(path)
    if path.include?('http')
      path 
    else
      base_url = extract_domain(url)
      #node_url = link
      mod_url = base_url << path
    end
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
