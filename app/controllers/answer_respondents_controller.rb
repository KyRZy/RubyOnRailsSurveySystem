class AnswerRespondentsController < ApplicationController
  before_action :set_answer_respondent, only: [:show, :edit, :update, :destroy]

  # GET /answer_respondents
  # GET /answer_respondents.json
  def index
    @answer_respondents = AnswerRespondent.all
  end

  # GET /answer_respondents/1
  # GET /answer_respondents/1.json
  def show
  end

  # GET /answer_respondents/new
  def new
    @answer_respondent = AnswerRespondent.new
  end

  # GET /answer_respondents/1/edit
  def edit
  end

  # POST /answer_respondents
  # POST /answer_respondents.json
  def create
    @answer_respondent = AnswerRespondent.new(answer_respondent_params)

    respond_to do |format|
      if @answer_respondent.save
        format.html { redirect_to @answer_respondent, notice: 'Answer respondent was successfully created.' }
        format.json { render :show, status: :created, location: @answer_respondent }
      else
        format.html { render :new }
        format.json { render json: @answer_respondent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answer_respondents/1
  # PATCH/PUT /answer_respondents/1.json
  def update
    respond_to do |format|
      if @answer_respondent.update(answer_respondent_params)
        format.html { redirect_to @answer_respondent, notice: 'Answer respondent was successfully updated.' }
        format.json { render :show, status: :ok, location: @answer_respondent }
      else
        format.html { render :edit }
        format.json { render json: @answer_respondent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answer_respondents/1
  # DELETE /answer_respondents/1.json
  def destroy
    @answer_respondent.destroy
    respond_to do |format|
      format.html { redirect_to answer_respondents_url, notice: 'Answer respondent was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer_respondent
      @answer_respondent = AnswerRespondent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_respondent_params
      params.require(:answer_respondent).permit(:answer_id, :respondent_id)
    end
end
