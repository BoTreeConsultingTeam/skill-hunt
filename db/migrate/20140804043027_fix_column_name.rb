class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :countries, :country_name, :name
    rename_column :roles,     :role_name, :name
    rename_column :skills,    :skill_name, :name
    rename_column :skills,    :skill_desc, :desc
  end
end
