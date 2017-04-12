json.extract! question, :id, :content, :order, :type, :min_responses, :max_responses, :survey_id, :created_at, :updated_at
json.url question_url(question, format: :json)
