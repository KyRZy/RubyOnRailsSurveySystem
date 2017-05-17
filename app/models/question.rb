class Question < ApplicationRecord
	has_many :answers, class_name:Answer, dependent: :destroy
	belongs_to :survey, class_name:Survey, optional: true
	validates_associated :answers
	validates :content, presence: true
	validates :order, presence: true
	validates :question_type, presence: true
end
