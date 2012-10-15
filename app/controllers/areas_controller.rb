class AreasController < ApplicationController
  # GET /areas
  # GET /areas.json
  def index
    @areas = Area.all
    logger.debug "*******************************************"
    logger.debug @areas.count
    logger.debug "*******************************************"
    @myareas = current_user.area_ids
    logger.debug "*******************************************"
    logger.debug @myareas.count
    logger.debug "*******************************************"


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @areas }
    end
  end

  # GET /areas/1
  # GET /areas/1.json
  def show
    @area = Area.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @area }
    end
  end

  # GET /areas/new
  # GET /areas/new.json
  def new
    @area = Area.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @area }
    end
  end

  # GET /areas/1/edit
  def edit
    @area = Area.find(params[:id])
  end

  # POST /areas
  # POST /areas.json
  def create
    @area = Area.new(params[:area])

    respond_to do |format|
      if @area.save
        format.html { redirect_to @area, notice: 'Area was successfully created.' }
        format.json { render json: @area, status: :created, location: @area }
      else
        format.html { render action: "new" }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /areas/1
  # PUT /areas/1.json
  def update
    @area = Area.find(params[:id])

    respond_to do |format|
      if @area.update_attributes(params[:area])
        format.html { redirect_to @area, notice: 'Area was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /areas/1
  # DELETE /areas/1.json
  def destroy
    @area = Area.find(params[:id])
    @area.destroy

    respond_to do |format|
      format.html { redirect_to areas_url }
      format.json { head :ok }
    end
  end

  def add_to_user
    t = params[:array].to_s.split(",")
    @areas = Area.find(t)
    logger.debug "**********************************1"
    logger.debug @areas
    logger.debug current_user.area_ids

    current_user.area_ids.clear
    logger.debug "**********************************2"
    logger.debug current_user.area_ids
    current_user.area_ids=t
    logger.debug "**********************************3"
    logger.debug current_user.area_ids
    current_user.save
    logger.debug "**********************************4"
    logger.debug current_user.area_ids
    respond_to do |format|
      format.html { redirect_to areas_url }
      format.json { head :ok }
    end
  end
end
