class AddCountryNameToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :country_name, :string
  end
end
