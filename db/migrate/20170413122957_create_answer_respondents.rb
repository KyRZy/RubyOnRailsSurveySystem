class CreateAnswerRespondents < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_respondents do |t|
      t.integer :answer_id
      t.integer :respondent_id

      t.timestamps
    end
  end
end
