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
	@survey.administrator_id = current_administrator.id
	@questions = []
	@answers = []
	question_param = params[:questions]
	answer_param = params[:answers]
	
	question_param.each.with_index do |content, index_q|
		indeks = index_q.to_s
		question = Question.new(:content => content, :order => index_q)
		replies = answer_param[indeks]
			replies.each.with_index do |reply, index_a|
				answer = Answer.new(:reply => reply, :order => index_a)
				answer.save!
				@answers.push(answer)
			end
		
		question.save!
		#question.answers = @answers   # do poprawienia, niepoprawne id!
		@questions.push(question)
		@answers = []
	end
	@survey.questions = @questions
	
    respond_to do |format|
      if @survey.save!
        format.html { redirect_to @survey, notice: 'Survey was successfully created.' }
        format.json { render :show, status: :created, location: @survey }
      else
        format.html { render :new }
        format.json { render json: @survey.errors.full_messages, status: :unprocessable_entity}
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
