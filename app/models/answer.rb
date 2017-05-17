class Answer < ApplicationRecord
	belongs_to :question, class_name:Question, optional: true, :foreign_key => "id"
	validates :reply, presence: true
	validates :order, presence: true
end
