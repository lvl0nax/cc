class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  load_and_authorize_resource
  def index
    # TODO: where date more or equal now
    now = DateTime.now
    @items = []
    event_conditions = []
    logger.debug "========================================="
    logger.debug params[:trainings].to_s
    logger.debug params[:events].to_s
    logger.debug params[:grants].to_s
    logger.debug params[:test].to_s
    logger.debug "##############"

    if params
      logger.debug params.to_s
    end

    if params[:trainings]
      logger.debug "tttttttttteeeeeeeeeeeeessssssssssssstttttttttttt"
    end
    event_conditions << params[:trainings]
    event_conditions << params[:events]
    event_conditions << params[:grants]
    event_conditions << params[:test]
    logger.debug event_conditions.to_s
    logger.debug "========================================="
    if params[:trainings] || params[:events] || params[:grants]
      if params[:events]  
        @items.concat( Event.search(params[:event_kinds], params[:event_areas]).to_a)
      end
      if params[:grants]
        @items.concat( Grant.search(params[:grant_areas]).to_a)
      end
      if params[:trainings]
        @items.concat( Training.search(params[:training_salary_type], params[:training_areas]).to_a)
      end  
        @items.concat( Month.all.to_a)
    else  
      
      @items.concat( Event.all.to_a)
      
      @items.concat( Grant.all.to_a)
      
      @items.concat( Training.all.to_a)
      #@items.concat( Training.where(:start_date.gte => now).to_a)
      
      @items.concat( Month.all.to_a)
    end
    @items.sort!{|x,y| x.start_date <=> y.start_date}
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
      format.xml { render xml: @items }
      format.js
    end
  end


  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @owner = User.find(@event.owner)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html { render :layout => false }# new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])
    @event.write_attributes(owner: current_user.id)
    respond_to do |format|
      if @event.save
        #current_user.events << @event
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end

  def add_participant
    current_user.events << @event
    redirect_to @event
  end

#TODO: before filter for this method
  def activities
    logger.debug "--------------------------------------------"
    @actions = current_user.actions
    logger.debug @actions
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @actions }
    end
  end
end
