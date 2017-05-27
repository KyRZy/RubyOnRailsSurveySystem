class Respondent < ApplicationRecord
	has_and_belongs_to_many :answers, :join_table => :answer_respondents
	validates :age, numericality: { only_integer: true, greater_than: 0, less_than: 100, allow_nil: true } 
	validates :ip_address, presence: true
end
