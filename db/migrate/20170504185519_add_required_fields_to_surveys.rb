class AddRequiredFieldsToSurveys < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :is_age_required, :boolean, :default => true
    add_column :surveys, :is_sex_required, :boolean, :default => true
    add_column :surveys, :is_education_required, :boolean, :default => true
    add_column :surveys, :is_location_required, :boolean, :default => true
  end
end
