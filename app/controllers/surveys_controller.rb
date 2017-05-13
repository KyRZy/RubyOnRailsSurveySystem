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
    @respondent = Respondent.new
  end
  
  def fill
	respondent_param = params[:respondent]
    @respondent = Respondent.create(:age => respondent_param[:age], :sex => respondent_param[:sex], :education => respondent_param[:education], :location => respondent_param[:location], :ip_address => request.remote_ip)
	question_param = params[:question]
	question_param.each do |question, answers|
		answers.each do |answer_id|
			answer_respondent = AnswerRespondent.create(:answer_id => answer_id, :respondent_id => @respondent.id)
		end
	end
	respond_to do |format|
      if @respondent.save
        format.html { redirect_to root_path, notice: 'Dziękujemy za wypełnienie ankiety!' }
        format.json { redirect_to root_path, notice: 'Dziękujemy za wypełnienie ankiety!' }
      else
        format.html { redirect_to root_path, notice: 'Wystąpił błąd przy wypełnianiu ankiety!' }
        format.json { redirect_to root_path, notice: 'Wystąpił błąd przy wypełnianiu ankiety!' }
      end
    end
  end

  # GET /surveys/new
  def new
    @survey = Survey.new
  end

  # GET /surveys/1/edit
  def edit
  end

  # POST /surveys
  # POST /surveys.json
  def create
  
	Survey.transaction do
		@survey = Survey.new(survey_params)
		@survey.administrator_id = current_administrator.id
		@questions = []
		@answers = []
		question_param = params[:questions]
		answer_param = params[:answers]
		question_type_param = params[:question_type]
		
		question_param.each.with_index do |content, index_q|
			indeks = index_q.to_s
			if question_type_param.nil?
				question = Question.new(:content => content, :order => index_q, :question_type => "JEDNOKROTNEGO_WYBORU")
			else
				if question_type_param.include?(indeks)
					question = Question.new(:content => content, :order => index_q, :question_type => "WIELOKROTNEGO_WYBORU")
				else
					question = Question.new(:content => content, :order => index_q, :question_type => "JEDNOKROTNEGO_WYBORU")
				end
			end
			question.save!
			replies = answer_param[indeks]
				replies.each.with_index do |reply, index_a|
					answer = Answer.new(:reply => reply, :order => index_a, :question_id => question.id)
					answer.save!
				end
			@questions.push(question)
		end
		@survey.questions = @questions
	end
    respond_to do |format|
      if @survey.save
        format.html { redirect_to @survey, notice: 'Poprawnie utworzono ankietę.' }
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
        format.html { redirect_to @survey, notice: 'Ankieta została poprawnie zaktualizowana.' }
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
      format.html { redirect_to surveys_url, notice: 'Poprawnie usunięto ankietę.' }
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
