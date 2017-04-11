class CreateSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :is_opened
      t.boolean :is_public
      t.boolean :is_available_for_all
      t.integer :administrator_id
      t.integer :category_id

      t.timestamps
    end
  end
end
