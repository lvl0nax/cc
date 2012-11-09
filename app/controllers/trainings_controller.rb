class TrainingsController < ApplicationController
  # GET /trainings
  # GET /trainings.json
  # TODO: check - may be we should make before filter


  def index
    @trainings = Training.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trainings }
    end
  end

  # GET /trainings/1
  # GET /trainings/1.json
  def show
    @training = Training.find(params[:id])
    #@requests = @training.requests
    @owner = User.find(@training.owner)
    #UserMailer.info_email(current_user).deliver
    respond_to do |format|
      format.html { render :layout => false }# show.html.erb
      format.json { render json: @training }
    end
  end

  # GET /trainings/new
  # GET /trainings/new.json
  def new
    @training = Training.new

    respond_to do |format|
      format.html { render :layout => false }# new.html.erb
      format.json { render json: @training }
    end
  end

  # GET /trainings/1/edit
  def edit
    @training = Training.find(params[:id])
  end

  # POST /trainings
  # POST /trainings.json
  def create
    @training = Training.create(params[:training])
    @training.write_attributes(owner: current_user.id) unless current_user.nil?
    respond_to do |format|
      if @training.save
        #current_user.trainings << @training

        format.html { redirect_to root_path, notice: 'Training was successfully created.' }
        format.json { render json: @training, status: :created, location: @training }
      else
        format.html { render action: "new" }
        format.json { render json: @training.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trainings/1
  # PUT /trainings/1.json
  def update
    @training = Training.find(params[:id])

    respond_to do |format|
      if @training.update_attributes(params[:training])
        format.html { redirect_to root_url, notice: 'Training was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @training.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trainings/1
  # DELETE /trainings/1.json
  def destroy
    @training = Training.find(params[:id])
    @training.destroy

    respond_to do |format|
      format.html { redirect_to trainings_url }
      format.json { head :ok }
    end
  end

  def send_mail
    UserMailer.info_email(current_user).deliver
  end

  def add_participant
    @training = Training.find(params[:id])
    current_user.trainings << @training
    #redirect_to root_url #@training
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :ok }
      format.js { status :ok }
    end
  end

  def del_participant
    training = Training.find(params[:id])
    current_user.training_ids.delete(training.id)
    training.user_ids.delete(current_user.id)
    current_user.save   
    training.save   
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :ok }
    end
  end

end
