# -*- encoding : utf-8 -*-
require 'will_paginate/array' 
class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  load_and_authorize_resource

  def index
    # TODO: where date more or equal now
    flash.keep

    now = DateTime.now
    @items = []
    @items.clear
    event_conditions = []
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
    else  
      
      # @items.concat( Event.where(:status => "ОДОБРЕНО").where(:start_date.gte => now).all.to_a)
      @items.concat( Event.isearch.to_a)
      
      # @items.concat( Grant.where(:status => "ОДОБРЕНО").where(:start_date.gte => now).all.to_a)
      @items.concat( Grant.isearch.to_a)

      # @items.concat( Training.where(:status => "ОДОБРЕНО").where(:start_date.gte => now).all.to_a)
      @items.concat( Training.isearch.to_a)
      
      #@items.concat( Training.where(:start_date.gte => now).to_a)
      
    end    

    months = Month.all.to_a.keep_if do |m|
      @items.any? { |a| a.start_date.month.to_i == m.number }
    end
    @items.concat(months)        

    unless (@items.blank?)
      @items.sort!{|x,y| x.start_date <=> y.start_date} if @items.length > 1

      unless params[:month].blank?
        @items.select! do |i| 
          i.start_date.month.to_i == params[:month].to_i && i.start_date.year.to_i == params[:year].to_i 
        end
        @items.unshift Month.where(:number => params[:month]).first if @items.length < 1
      end
    end    

    @items = @items.paginate(:page => params[:page], :per_page => 12)
    
    # @events, @trainings, @grants = [Event, Training, Grant].map do |clazz|
    #   clazz.paginate(:page => params[clazz.to_s.downcase + "_page"], :order => 'start_date')
    # end


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

#TODO: before filter for this method
  # def activities
  #   logger.debug "--------------------------------------------"
  #   @user = User.find(params[:id])
  #   @actions = @user.actions
  #   logger.debug @actions
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @actions }
  #   end
  # end

  def not_approved
    now = DateTime.now
    @items = []
    
    @items.concat Training.any_in(:status => ["", "УДАЛЕНО", "НОВОЕ"]).where(:start_date.gte => DateTime.now).all.to_a
    #logger.debug @items
    @items.concat Event.any_in(:status => ["", "УДАЛЕНО", "НОВОЕ"]).where(:start_date.gte => DateTime.now).all.to_a
    #logger.debug @items
    @items.concat Grant.any_in(:status => ["", "УДАЛЕНО", "НОВОЕ"]).where(:start_date.gte => DateTime.now).all.to_a


    unless (@items.blank?)
      @items.sort!{|x,y| x.start_date <=> y.start_date} if @items.length > 1
    end 
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
      format.xml { render xml: @items }
      format.js
    end
  end
end
