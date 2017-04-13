json.extract! respondent, :id, :age, :sex, :education, :location, :ip_address, :created_at, :updated_at
json.url respondent_url(respondent, format: :json)
