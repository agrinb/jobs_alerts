desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :development do
  puts "Updating feed..."
  User.find_jobs
  puts "done."
end

