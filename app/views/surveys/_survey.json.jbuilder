json.extract! survey, :id, :name, :start_date, :end_date, :is_opened, :is_public, :is_available_for_all, :administrator_id, :category_id, :created_at, :updated_at
json.url survey_url(survey, format: :json)
