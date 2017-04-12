class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.text :content
      t.integer :order
      t.string :type
      t.integer :min_responses
      t.integer :max_responses
      t.integer :survey_id

      t.timestamps
    end
  end
end
