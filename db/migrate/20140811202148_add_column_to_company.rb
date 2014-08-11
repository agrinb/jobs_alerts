class AddColumnToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :uid, :integer, null: false
    add_column :companies, :user_id, :integer
  end
end
