class KondatesController < ApplicationController
  before_action :require_signed_in, only: %i[new edit create update destroy]

  private def require_same_user
    if current_user.nil? || current_user.id != @kondate.user_id
      redirect_to @kondate, notice: 'You cannot edit other\'s kondate.'
    end
  end

  # GET /kondates
  def index
    @kondates = Kondate.all
  end

  # GET /kondates/1
  def show
    @kondate = Kondate.find(params[:id])
  end

  # GET /kondates/new
  def new
    @kondate_form = KondateForm.new(Kondate.new)
  end

  # GET /kondates/1/edit
  def edit
    @kondate = Kondate.find(params[:id])
    require_same_user
    @kondate_form = KondateForm.new(@kondate)
  end

  # POST /kondates
  def create
    @kondate_form = KondateForm.new(Kondate.new(user_id: current_user.id))
    @kondate_form.apply(kondate_form_params)

    if @kondate_form.save
      redirect_to @kondate_form.kondate, notice: 'Kondate was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /kondates/1
  def update
    @kondate = Kondate.find(params[:id])
    require_same_user
    @kondate_form = KondateForm.new(@kondate)
    @kondate_form.apply(kondate_form_params)

    if @kondate_form.save
      redirect_to @kondate, notice: 'Kondate was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /kondates/1
  def destroy
    kondate = Kondate.find(params[:id])
    kondate.destroy
    redirect_to kondates_url, notice: 'Kondate was successfully destroyed.'
  end

  private

  # Only allow a list of trusted parameters through.
  def kondate_form_params
    params.require(:kondate).permit(:title, :description, :main_recipe_id, :side_recipe_ids)
  end
end
