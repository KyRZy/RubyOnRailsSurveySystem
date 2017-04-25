class Question < ApplicationRecord
	belongs_to :survey, class_name:Survey
	has_many :answers, class_name:Answer, dependent: :destroy, foreign_key: :id
end
