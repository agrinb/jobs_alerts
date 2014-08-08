class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company
      t.string :url
      t.text :keywords
      t.text :last_fetch
    end
  end
end
