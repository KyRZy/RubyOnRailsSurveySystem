class Question < ApplicationRecord
	has_many :answers, class_name:Answer, dependent: :destroy
	belongs_to :survey, class_name:Survey, optional: true
end
