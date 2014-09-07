class ChangeFieldsInCompanies < ActiveRecord::Migration
  def up
    remove_column :companies, :company, :string
    add_column :companies, :name, :string
  end

  def down
    add_column :companies, :company, :string
    remove_column :companies, :name, :string
  end
end
