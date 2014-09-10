# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities " = City.create([{ name: 'Chicago' },, { name: 'Copenhagen' },])
#   Mayor.create(name: 'Emanuel', city: cities.first)


links = [
          { "http://www.squarespace.com/about/careers " => ["engineer", "software", "advisor"]},

          { "https://a127-jobs.nyc.gov/jobsearch.html?category=CAS" => ["analyst", "assistant"]},

          { "http://jobs.intuit.com/careers/customer-service-and-support-jobs" => ["quality", "tax"]},

          { "https://www.facebook.com/careers/teams/product-management" => ["product"]},

          {"http://www.hugeinc.com/careers/technology" => ["Analyst", "Engineer"]},

          {"http://www.goldmansachs.com/careers/why-goldman-sachs/our-divisions/technology/index.html" => ["Developer"]},

          {"http://www.twosigma.com/careers.html" => ["recruiter", "manager", "employee"]},

          {"http://connect.att.jobs/careers/corporate" => ["Atlanta", "manager"]},

          {"http://www.spacex.com/careers/list" => ["flight safety", "mission"]},

          {"http://careers.homedepot.com/jobs/recent" => ["Atlanta", "service", "manager"]},

          {"http://www.oculusvr.com/company/careers/#open-positions" => ["hardware", "Compliance"]}
        ]
companies = []
links.each do |link|
  link.each do |k, v|
  name = k.match(/^https?\:\/\/([^\/:?#]+)(?:[\/:?#]|$)/i)
  companies << Company.create(url: k, keywords: v, name: name[1], user_id: 1, uid: "101147046698959722496" )
  end
end


