class Answer < ApplicationRecord
	belongs_to :question, class_name:Question, optional: true, foreign_key: :id
end
