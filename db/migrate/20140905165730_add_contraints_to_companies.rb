class AddContraintsToCompanies < ActiveRecord::Migration
  def up
    remove_column :companies, :user_id, :integer
    add_column :companies, :user_id, :integer, presence: true
  end

  def down
    remove_column :companies, :user_id, :integer, presence: true
    add_column :companies, :user_id, :integer
  end
end
