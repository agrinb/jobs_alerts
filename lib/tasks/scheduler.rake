desc "Fetches jobs updates for users"
task :update_feed => :environment do
  User.find_jobs
end

