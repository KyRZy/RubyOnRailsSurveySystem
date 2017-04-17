require 'test_helper'

class SurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @survey = surveys(:one)
  end

  test "should get index" do
    get surveys_url
    assert_response :success
  end

  test "should get new" do
    get new_survey_url
    assert_response :success
  end

  test "should create survey" do
    assert_difference('Survey.count') do
      post surveys_url, params: { survey: { administrator_id: @survey.administrator_id, category_id: @survey.category_id, end_date: @survey.end_date, is_available_for_all: @survey.is_available_for_all, is_opened: @survey.is_opened, is_public: @survey.is_public, name: @survey.name, start_date: @survey.start_date } }
    end

    assert_redirected_to survey_url(Survey.last)
  end

  test "should show survey" do
    get survey_url(@survey)
    assert_response :success
  end

  test "should get edit" do
    get edit_survey_url(@survey)
    assert_response :success
  end

  test "should update survey" do
    patch survey_url(@survey), params: { survey: { administrator_id: @survey.administrator_id, category_id: @survey.category_id, end_date: @survey.end_date, is_available_for_all: @survey.is_available_for_all, is_opened: @survey.is_opened, is_public: @survey.is_public, name: @survey.name, start_date: @survey.start_date } }
    assert_redirected_to survey_url(@survey)
  end

  test "should destroy survey" do
    assert_difference('Survey.count', -1) do
      delete survey_url(@survey)
    end

    assert_redirected_to surveys_url
  end
end