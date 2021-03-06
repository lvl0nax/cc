# -*- encoding : utf-8 -*-
require 'will_paginate/array'
class EventsController < ApplicationController
  include EventsHelper

  load_and_authorize_resource

  def index
    @event_id = params[:event_id]
    @trainings_odobreno = Training.where(:status=>'ОДОБРЕНО', :request_date => {'$gte' => Time.now})
    @grants_odobreno = Grant.where(:status=>'ОДОБРЕНО', :start_date => {'$gte' => Time.now})
    @events_odobreno = Event.where(:status=>'ОДОБРЕНО', :request_date => {'$gte' => Time.now})
    
  @events = []
  existing_ids = []      
    
    if params[:grant]      
      @grants = Grant.where(:status=>'ОДОБРЕНО')
      @grants = @grants.in(:area_ids=>params[:grant][:areas]) if params[:grant][:areas]
      @grants = @grants.where(:direction=>params[:grant][:direction]) if params[:grant][:direction]
    end# unless params[:check_grant].nil?

    if params[:event]
      @evs = Event.where(:status=>'ОДОБРЕНО')
      @evs = @evs.in(:area_ids=>params[:event][:areas]) if params[:event][:areas]
      @evs = @evs.in(:area_types=>params[:event][:area_types]) if params[:event][:area_types]
      
    end #unless params[:check_event].nil?

    if params[:training]
      @trainings = Training.where(:status=>'ОДОБРЕНО')
      @trainings = @trainings.in(:area_ids=>params[:training][:areas]) if params[:training][:areas]
      @trainings = @trainings.in(:salary_type => params[:training][:payments]) if params[:training][:payments]
      @trainings = @trainings.in(:owner => params[:training][:compinfos]) if params[:training][:compinfos]

    end #unless params[:check_training].nil?
  

  if not params[:month].nil? or not cookies[:month].blank?         
     month = params[:month].to_i
     year = params[:year].to_i
     now = DateTime.now.change(:day => 1, :month => month + 1, :year=> year)
     @trainings = Training.where(:status=>'ОДОБРЕНО') if @trainings.nil?
     @trainings = @trainings.where(:start_date => {'$gte' => now.beginning_of_month,'$lt' => now.end_of_month}) if params[:check_training].nil?
    

     @evs = Event.where(:status=>'ОДОБРЕНО') if @evs.nil?
     @evs = @evs.where(:start_date => {'$gte' => now.beginning_of_month,'$lt' => now.end_of_month}) if params[:check_event].nil?
    

     @grants = Grant.where(:status=>'ОДОБРЕНО') if @grants.nil?
     @grants = @grants.where(:start_date => {'$gte' => now.beginning_of_month,'$lt' => now.end_of_month}) if params[:check_grant].nil?
    
     cookies[:month] = params[:month]   
      
     if not params[:month].eql?('undefined')
       month = params[:month].to_i
       year = params[:year].to_i
       now = DateTime.now.change(:day => 1, :month => month + 1, :year=> year)
       
       @trainings = Training.where(:status=>'ОДОБРЕНО') if @trainings.nil?
       unless params[:check_training].nil?
        @trainings = @trainings.where(:start_date => {'$gte' => now.beginning_of_month,'$lt' => now.end_of_month})
       else
        @trainings =[]
       end
             
       @evs = Event.where(:status=>'ОДОБРЕНО') if @evs.nil?
       unless params[:check_event].nil?
        @evs = @evs.where(:start_date => {'$gte' => now.beginning_of_month,'$lt' => now.end_of_month})
       else
        @evs = []
       end

       @grants = Grant.where(:status=>'ОДОБРЕНО') if @grants.nil?
       unless params[:check_grant].nil?
        @grants = @grants.where(:start_date => {'$gte' => now.beginning_of_month,'$lt' => now.end_of_month}) 
       else
        @grants = []
       end
      
       cookies[:month] = params[:month]
        

     end
  end  
  
  years = %w[2012 2013]
  months =  %w[jan feb mar apr may june july aug sept oct nov dec]
  years.each do |year|      
      months.each_with_index do |month, index|        
        if Grant.month(index, year.to_i).count > 0 || Event.month(index, year.to_i).count > 0 || Training.month(index, year.to_i).count > 0
          
          @events << Month.new(:number=>index, :name=>month)           
          Grant.month(index, year.to_i).each do |grant|           
            if @grants.nil?
              
              @events << grant
              grant.visible = true
              existing_ids << grant.id
            else            
              @events << grant # if @grants.include?(grant)
              existing_ids << grant.id if @grants.include?(grant)
              grant.visible = true if @grants.include?(grant)
            end          
          end #if params[:check_grant].nil?

          Event.month(index, year.to_i).each do |event|            
            if @evs.nil?
              @events << event
              event.visible = true
              existing_ids << event.id
            else
              @events << event # if @grants.include?(grant)
              existing_ids << event.id if @evs.include?(event)
              event.visible = true if @evs.include?(event)
            end
          end #if params[:check_event].nil?

          Training.month(index, year.to_i).each do |training|
            if @trainings.nil?
              @events << training
              training.visible = true
              existing_ids << training.id
            else

              @events << training # if @grants.include?(grant)
              existing_ids << training.id if @trainings.include?(training)
              training.visible = true if @trainings.include?(training)
            end
          end #if params[:check_training].nil?        
        end
      end      
    end
    @events = sort_array_events(@events)
    
    if @events.count == 0
        months.each_with_index do |month, index|
        @events << Month.new(:number=>index, :name=>month)
       end
    end 

  @events = @events.paginate(:page => params[:page], :per_page => 12)

  existing_ids.each do |event|
    params[:grants].delete event.to_s if not params[:grants].nil? and params[:grants].include?(event.to_s)
  end


  @ids_to_show = []


  ### Getting grant ids which will fade in
  existing_ids.each do |event|
    @ids_to_show << event.to_s if not params[:grants].nil? and not params[:grants].include?(event.to_s)
  end


  ### Getting grant ids which will fade out
  @ids_to_delete = []
  unless params[:grants].nil?
    params[:grants].each do |grant|
      @ids_to_delete << grant
    end
  end

  unless params[:trainings].nil?
    params[:trainings].each do |training|
      @ids_to_delete << training
    end
  end

  unless params[:events].nil?
    params[:events].each do |event|
      @ids_to_delete << event
    end
  end  
  
    respond_to do |format|
      format.html
      format.json { render json: { delete:@ids_to_delete, show:@ids_to_show } }
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
      format.html { render :layout => false }# show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    unless params.nil?
      @x = params[:x]
      @y = params[:y]   
    end
    @event = Event.new

    respond_to do |format|
      format.js { render :layout => false }# new.html.erb
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
    @event.write_attributes(owner: current_user.id) unless current_user.nil?

    respond_to do |format|
      if @event.save
        # deleting cookie with image id, if it exists
        cookies.delete :event_image unless cookies[:event_image].nil?
        format.html { redirect_to root_path, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render json: @event.errors }
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
        format.html { redirect_to root_url, notice: 'Training was successfully updated.'}
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
    event = Event.find(params[:id])
    current_user.events << event
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :ok }
      format.js { status :ok }
    end
  end

  def del_participant
    event = Event.find(params[:id])
    current_user.event_ids.delete(event.id)
    event.user_ids.delete(current_user.id)
    current_user.save   
    event.save   
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :ok }
    end
  end

  def not_approved

    #@items = []
    
    #@items += Training.any_in(:status => [nil, "УДАЛЕНО", "НОВОЕ"]).where(:start_date.gte => DateTime.now).all.to_a
    #logger.debug @items
    #@items += Event.any_in(:status => [nil, "УДАЛЕНО", "НОВОЕ"]).where(:start_date.gte => DateTime.now).all.to_a
    #logger.debug @items
    #@items += Grant.any_in(:status => [nil, "УДАЛЕНО", "НОВОЕ"]).where(:start_date.gte => DateTime.now).all.to_a
    @count = EventParent.any_in(:status => [nil, "УДАЛЕНО", "НОВОЕ"]).count
    @items = EventParent.any_in(:status => [nil, "УДАЛЕНО", "НОВОЕ"])
    
    unless @items.blank?
      @items.sort!{|x,y| x.start_date <=> y.start_date} if @items.length > 1
    end 
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
      format.xml { render xml: @items }
      format.js
    end
    puts @items.count
  end

  def update_index
    @items = []
    render json:@grants
  end

  def event_status
    @event = EventParent.find(params[:event_id])
    @event.status = 'ОДОБРЕНО'
    @event.save
    render :text => ''
  end

  def event_delete
    @event = EventParent.find(params[:event_id])
    @event.destroy
    # @count = EventParent.any_in(:status => [nil, "УДАЛЕНО", "НОВОЕ"]).count
    # @count -=1 unless @count == 0 
    render :text => ''
  end

end
