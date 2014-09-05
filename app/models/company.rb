class Company < ActiveRecord::Base
  validates :uid, presecnce: true
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
    binding.pry
    companies.each do |company|
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
            user_jobs <<
              { company.user =>
                { company.company =>
                  { node.text => node['href'] }
                }
              }
          end
        end
      end
    end
    user_jobs
  end
end
