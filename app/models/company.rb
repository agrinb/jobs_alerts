require 'open-uri'

class Company < ActiveRecord::Base
  validates :uid, presence: true
  validates :user_id, presence: true
  validates :url, presence: true
  validates :keywords, presence: true
  serialize :keywords
  belongs_to :user


  def self.last_fetch(company)
    last_fetch = Nokogiri::HTML(company.last_fetch)
    previous = []
    keywords = company.keywords
    a_nodes = last_fetch.css("a")
    kwords = []
    keywords.each do |k|
       kwords << k.downcase
       kwords << k.capitalize
    end
    kwords.each do |keyword|
      a_nodes.each do |node|
        #binding.pry
        if node.text.include?(keyword)
          previous << node['href']
        end
      end
    end
    binding.pry
    previous
  end

  def self.not_in_last_fetch(company, node)
    binding.pry
    !last_fetch(company).include?(node['href'])
  end


  def self.find_jobs
    users = User.all
    companies = users.map { |user| user.companies }
    user_jobs = []
    companies[0].each do |company|
      keywords = company.keywords
      doc = Nokogiri::HTML(open(company.url))
      a_nodes = doc.css("a")
      kwords = []
      keywords.each do |k|
         kwords << k.downcase
         kwords << k.capitalize
      end
      kwords.each do |keyword|
        a_nodes.each do |node|
          if node.text.include?(keyword) && not_in_last_fetch(company, node)
         # if node.text.include?(keyword)
            job = Job.create(company_id: company.id, url: node['href'], title: node.text)
            user_jobs <<
              { company.user =>
                { company.name =>
                  { job.title => job.url }
                }
              }
          end
        end
      end
      company.last_fetch = Nokogiri::HTML(open(company.url)).to_s
      company.save
    end
    binding.pry
    user_jobs
  end

end
