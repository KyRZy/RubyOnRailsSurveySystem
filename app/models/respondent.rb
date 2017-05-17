class Respondent < ApplicationRecord
	validates :age, numericality: { only_integer: true, greater_than: 0, less_than: 100 }
	validates :ip_address, presence: true
end
