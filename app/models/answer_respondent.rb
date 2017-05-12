class AnswerRespondent < ApplicationRecord
	has_one :answer, class_name:Answer, :foreign_key => "id"
	has_one :respondent, class_name:Respondent, :foreign_key => "id"
end
