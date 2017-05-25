class Answer < ApplicationRecord
	has_and_belongs_to_many :respondents, :join_table => :answer_respondents
	belongs_to :question, class_name:Question, optional: true, :foreign_key => "id"
	validates :reply, presence: true
	validates :order, presence: true
end
