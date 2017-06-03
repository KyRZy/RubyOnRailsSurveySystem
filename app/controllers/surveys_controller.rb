class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy, :stats, :is_survey_creator?, :is_opened?, :is_available?]
	before_action :already_filled_this_survey?, only: [:show]
	before_action :is_survey_author?, only: [:show]
	before_action :is_opened?, only: [:show]
	before_action :is_logged?, only: [:new]
	before_action :is_available?, only: [:stats]

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
	Survey.transaction do
		respondent_param = params[:respondent]
		if(respondent_param.nil?)
			@respondent = Respondent.create(:age => nil, :sex => nil, :education => nil, :location => nil, :ip_address => request.remote_ip)
		else
			@respondent = Respondent.create(:age => respondent_param[:age], :sex => respondent_param[:sex], :education => respondent_param[:education], :location => respondent_param[:location], :ip_address => request.remote_ip)
		end
		question_param = params[:question]
		question_param.each do |question, answers|
			answers.each do |answer_id|
				answer_respondent = AnswerRespondent.create(:answer_id => answer_id, :respondent_id => @respondent.id)
				if !answer_respondent.valid?
					raise ActiveRecord::Rollback
				end
			end
		end
		respond_to do |format|
		  if @respondent.save
			format.html { redirect_to root_path }
			format.json { redirect_to root_path, notice: 'Dziękujemy za wypełnienie ankiety!' }
			flash[:success] = 'Dziękujemy za wypełnienie ankiety!'
		  else
		    raise ActiveRecord::Rollback
			format.html { redirect_to root_path }
			format.json { redirect_to root_path, notice: 'Wystąpił błąd przy wypełnianiu ankiety!' }
			flash[:danger] = 'Wystąpił błąd przy wypełnianiu ankiety!'
		  end
		end
	end
  end

  # GET /surveys/new
  def new
    @survey = Survey.new
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
				if !question.save 
					raise ActiveRecord::Rollback
				end
				replies = answer_param[indeks]
					replies.each.with_index do |reply, index_a|
						answer = Answer.new(:reply => reply, :order => index_a, :question_id => question.id)
						if !answer.save
							raise ActiveRecord::Rollback
						end
					end
				@questions.push(question)
			end
			@survey.questions = @questions
		respond_to do |format|
		  if @survey.save
			format.html { redirect_to root_path }
			format.json { redirect_to root_path }
			flash[:success] = 'Poprawnie utworzono ankietę.'
		  else
			raise ActiveRecord::Rollback
			format.html { render :new }
			format.json { render json: @survey.errors.full_messages, status: :unprocessable_entity}
		  end
		end
	end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey.destroy
    respond_to do |format|
      format.html { redirect_to surveys_url }
      format.json { head :no_content }
			flash[:success] = 'Poprawnie usunięto ankietę.'
    end
  end

  def stats
	
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
		def already_filled_this_survey?
			answer_respondents = AnswerRespondent.where(answer_id:@survey.questions.first.answers).each do |ar|
				if Respondent.exists?(ar.respondent_id)
					if Respondent.find(ar.respondent_id).ip_address == request.remote_ip
						flash[:danger] = "Każdy użytkownik może wypełnić ankietę TYLKO RAZ."
						#redirect_to root_path   ##odkomentować jeśli chce się zablokować ponowny dostęp do ankiety po jej wypełnieniu
					end
				end
			end
		end

		def is_logged?
			if current_administrator == nil
				flash[:danger] = "Musisz być zalogowany, żeby mieć dostęp do tej podstrony."
				redirect_to root_path
			end
		end

		def is_survey_author?
			if (current_administrator != nil && current_administrator.id == @survey.administrator_id)
					@is_survey_author = true
			else
					@is_survey_author = false
			end
		end
		
		def is_opened?
			if (Time.now <=> @survey.start_date) == -1 || (Time.now <=> @survey.end_date) == 1
				flash[:danger] = "Ankieta nie jest w tej chwili dostępna."
				redirect_to root_path
			end
		end

		def is_available?
			if @survey.is_available_for_all || (current_administrator != nil && current_administrator.id == @survey.administrator_id)
				return
			else
				respondent_has_access = false
				if @survey.is_public
					answer_respondents = AnswerRespondent.where(answer_id:@survey.questions.first.answers).each do |ar|
						if Respondent.exists?(ar.respondent_id)
							if Respondent.find(ar.respondent_id).ip_address == request.remote_ip
								respondent_has_access = true
							end
						end
					end
				end
				if !respondent_has_access
					flash[:danger] = "Nie masz dostępu do wyników ankiety"
					redirect_to root_path
				end
			end
		end

    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_params
      params.require(:survey).permit(:name, :start_date, :end_date, :is_opened, :is_public, :is_available_for_all, :administrator_id, :category_id, :is_age_required, :is_sex_required, :is_education_required, :is_location_required)
    end
end
