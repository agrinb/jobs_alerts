require 'open-uri'

class Company < ActiveRecord::Base
  validates :uid, presence: true
  validates :user_id, presence: true
  validates :url, presence: true
  validates :keywords, presence: true
  serialize :keywords
  belongs_to :user



  def fetch_html(company)
    doc = Nokogiri::HTML(open(company.url))
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
          if node.text.include?(keyword)
            job = Job.create(company_id: company.id, url: node['href'], title: node.text)
            user_jobs <<
              { company.user =>
                { company.company =>
                  { job.title => job.url }
                }
              }
          end
        end
      end
    end
    binding.pry
    user_jobs
  end
end
