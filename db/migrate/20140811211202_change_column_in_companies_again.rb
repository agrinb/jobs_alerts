class ChangeColumnInCompaniesAgain < ActiveRecord::Migration
  def change
    change_column :companies, :uid, :string
  end
end
