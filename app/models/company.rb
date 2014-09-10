require 'open-uri'

class Company < ActiveRecord::Base
  validates :uid, presence: true
  validates :user_id, presence: true
  validates :url, presence: true
  validates :keywords, presence: true
  serialize :keywords
  belongs_to :user
  has_many :jobs, dependent: :destroy

  def self.fetch_dom
    Company.all.each do |company|
      company.last_fetch = Nokogiri::HTML(open(company.url))
      company.save
    end
  end

  def self.find_links(company)
    links = []
    keywords = company.keywords
    last_fetch = Nokogiri::HTML(company.last_fetch)
    a_nodes = last_fetch.css("a")
    kwords = []
    keywords.each do |k|
      kwords << k.downcase
      kwords << k.capitalize
    end
    kwords.each do |keyword|
      a_nodes.each do |node|
        if node.text.include?(keyword)
          job = Job.create(company_id: company.id, url: node['href'], title: node.text)
          links << job
        end
      end
    end
    links
  end

   def self.user_links(user)
    new_links = []
    user.companies.each do |company|
      links = find_links(company)
      links.select {|link| link.created_at - company.created_at > 1.day }
    end

  end


  def self.find_jobs
    users = User.all
    users.each do |user|
      user_links(user)
    end
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
