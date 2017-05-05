class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy]

  # GET /surveys
  # GET /surveys.json
  def index
    @surveys = Survey.all
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
  end

  # GET /surveys/new
  def new
    @survey = Survey.new
    @categories = Category.all
  end

  # GET /surveys/1/edit
  def edit
  end

  # POST /surveys
  # POST /surveys.json
  def create
    @survey = Survey.new(survey_params)
	@survey.administrator_id = params[:administrator_id]
	
	question_param = params[:questions]
	answer_param = params[:answers]
	
	question_param.each.with_index do |content, index_q|
		question = Question.create(:content => content, :order => index_q)
		#@questions.push(question)
		#question.save
		answer_param.each.with_index do |answer, index_a|
			Answer.create(:reply => answer, :order => index_a, :question_id => index_q)
		end
	end
	#@survey.questions = questions
	
	#@survey.name = params[:survey][:name]
	#@survey.category_id = params[:survey][:category_id]
	#@survey.is_age_required = params[:survey][:is_age_required]
	#@survey.is_sex_required = params[:survey][:is_sex_required]
	#@survey.is_education_required = params[:survey][:is_education_required]
	#@survey.is_location_required = params[:survey][:is_location_required]
	#@survey.is_public = params[:survey][:is_public]
	#@survey.is_available_for_all = params[:survey][:is_available_for_all]
	
	#@survey.start_date = params[:survey][:start_date]
	#@survey.end_date = params[:survey][:end_date]	
	
    respond_to do |format|
      if @survey.save
        format.html { redirect_to @survey, notice: 'Survey was successfully created.' }
        format.json { render :show, status: :created, location: @survey }
      else
        format.html { render :new }
        format.json { render json: @survey.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /surveys/1
  # PATCH/PUT /surveys/1.json
  def update
    respond_to do |format|
      if @survey.update(survey_params)
        format.html { redirect_to @survey, notice: 'Survey was successfully updated.' }
        format.json { render :show, status: :ok, location: @survey }
      else
        format.html { render :edit }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey.destroy
    respond_to do |format|
      format.html { redirect_to surveys_url, notice: 'Survey was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_params
      params.require(:survey).permit(:name, :start_date, :end_date, :is_opened, :is_public, :is_available_for_all, :administrator_id, :category_id, :is_age_required, :is_sex_required, :is_education_required, :is_location_required)
    end
end
