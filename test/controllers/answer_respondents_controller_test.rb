require 'test_helper'

class AnswerRespondentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @answer_respondent = answer_respondents(:one)
  end

  test "should get index" do
    get answer_respondents_url
    assert_response :success
  end

  test "should get new" do
    get new_answer_respondent_url
    assert_response :success
  end

  test "should create answer_respondent" do
    assert_difference('AnswerRespondent.count') do
      post answer_respondents_url, params: { answer_respondent: { answer_id: @answer_respondent.answer_id, respondent_id: @answer_respondent.respondent_id } }
    end

    assert_redirected_to answer_respondent_url(AnswerRespondent.last)
  end

  test "should show answer_respondent" do
    get answer_respondent_url(@answer_respondent)
    assert_response :success
  end

  test "should get edit" do
    get edit_answer_respondent_url(@answer_respondent)
    assert_response :success
  end

  test "should update answer_respondent" do
    patch answer_respondent_url(@answer_respondent), params: { answer_respondent: { answer_id: @answer_respondent.answer_id, respondent_id: @answer_respondent.respondent_id } }
    assert_redirected_to answer_respondent_url(@answer_respondent)
  end

  test "should destroy answer_respondent" do
    assert_difference('AnswerRespondent.count', -1) do
      delete answer_respondent_url(@answer_respondent)
    end

    assert_redirected_to answer_respondents_url
  end
end
