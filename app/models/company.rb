class Company < ActiveRecord::Base
  serialize :keywords
  belongs_to :user
end
