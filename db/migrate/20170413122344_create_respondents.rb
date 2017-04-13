class CreateRespondents < ActiveRecord::Migration[5.0]
  def change
    create_table :respondents do |t|
      t.string :age
      t.string :sex
      t.string :education
      t.string :location
      t.string :ip_address

      t.timestamps
    end
  end
end
