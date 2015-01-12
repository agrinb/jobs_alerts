class CompaniesController < ApplicationController
  require 'open-uri'
  skip_before_filter  :verify_authenticity_token


  def new
    @company = Company.new
  end

  def create
    @company = Company.new
    user = User.find_or_create_by(uid: company_params['uid'])
    @company.assign_attributes({ user_id: user.id, uid: user.uid, name: company_params['name'], keywords: company_params['keywords'], url: company_params['url']})
    if @company.save
      respond_to do |format|
        format.json { render :json => {:status => 200, :text => "ok"} }
      end
      user.find_my_jobs
    else
      respond_to do |format|
       format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end
 

  # def create
  #   @company = Company.new
  #   @company.user = User.find_by(uid: company_params['uid'])
  #   @company.last_fetch = Nokogiri::HTML(open(company_params['url']))
  #   binding.pry
  #   if @company.save
  #     respond_to do |format|
  #       format.json { render :json => {:status => 200, :text => "ok"} }
  #     end
  #   else
  #     respond_to do |format|
  #      format.json { render json: @company.errors, status: :unprocessable_entity }
  #    end
  #   end
  # end
  ##

  # def show
  #   @company = Company.find(params[:id])
  #   @company.find_jobs
  #   keywords = @company.keywords
    
  #   begin
  #     doc = Nokogiri::HTML(open(@company.url))
  #   rescue Errno::ENOENT => e
  #     $stderr.puts "Caught the exception: #{e}"
  #   end
  #   a_nodes = doc.css("a")
  #   kwords = []
  #   keywords.each do |k|
  #      kwords << k.downcase
  #      kwords << k.capitalize
  #   end
  #   jobs_array = []
  #   kwords.each do |keyword|
  #     a_nodes.each do |node|
  #       if node.text.include?(keyword)
  #         jobs_array << { node.text => node['href'] }
  #       end
  #     end
  #   end
  #   process_jobs(jobs_array, @company)  
  # end

  # def process_jobs(jobs_array, company)
  #   if company.url.include?('craigslist.org/search')
  #     process_cl_urls(jobs_array, @company.url)
  #   else
  #     process_other_urls(company)
  #   end
  # end

  # def process_other_urls
  # end

  # def process_cl_urls(jobs_array, url)
  #   processed_jobs = []
  #   jobs_array.each do |job|
  #     unless job.values.include?('http://')
  #       base_url = url.split('/search').first
  #       mod_url = base_url << job.values.first
  #       modified_job = { job.keys.first => mod_url }
  #     end
  #     processed_jobs << modified_job
  #   end
  #   processed_jobs
  # end


  def company_params
    params.permit(:url, {:keywords => []}, :uid, :user_id, :user_email, :name, :job_url)
  end
end
