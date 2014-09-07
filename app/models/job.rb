class Job < ActiveRecord::Base
  has_many :users, through: :companies
end
