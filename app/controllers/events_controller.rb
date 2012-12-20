# -*- encoding : utf-8 -*-
require 'will_paginate/array'
class EventsController < ApplicationController

  load_and_authorize_resource

  def index
  @events = []
  existing_ids = []
  if params[:grant]
    @grants = Grant.where(:status=>'ОДОБРЕНО')
    @grants = @grants.in(:area_ids=>params[:grant][:areas]) if params[:grant][:areas]
    @grants = @grants.where(:direction=>params[:grant][:direction]) if params[:grant][:direction]
  end

  puts params.inspect
  if params[:event]
    @evs = Event.where(:status=>'ОДОБРЕНО')
    @evs = @evs.in(:area_ids=>params[:event][:areas]) if params[:event][:areas]
    @evs = @evs.where(:payment=>params[:event][:payments]) if params[:event][:areas]
  end

  if params[:training]
    @trainings = Training.where(:status=>'ОДОБРЕНО')
    @trainings = @trainings.in(:area_ids=>params[:training][:areas]) if params[:training][:areas]
    @trainings = @trainings.in(:payment => params[:training][:payments]) if params[:training][:payments]
  end

  years = %w[2012 2013]
  years.each do |year|
      months =  %w[jan feb mar apr may june july aug sept oct nov dec]
      months.each_with_index do |month, index|
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
        end

        Event.month(index, year.to_i).each do |event|
          @events << event
        end

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
        end

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
    @event.write_attributes(owner: current_user.id) unless current_user.nil?
    respond_to do |format|
      if @event.save
        #current_user.events << @event
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

    @items = EventParent.any_in(:status => [nil, "УДАЛЕНО", "НОВОЕ"])
    puts @items.count

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

end
