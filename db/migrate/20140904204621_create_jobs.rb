class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title, presence: true
      t.string :url
    end
  end
end
