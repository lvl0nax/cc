# -*- encoding : utf-8 -*-
class ResumesController < ApplicationController
  
  require 'devise'
  # GET /resumes
  # GET /resumes.json
  def index

    @resumes = Resume.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resumes }
    end
  end

  # GET /resumes/1
  # GET /resumes/1.json
  def show
    @resume = current_user.try(:resume)#Resume.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resume }
    end
  end

  # GET /resumes/new
  # GET /resumes/new.json
  def new
    @resume = Resume.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @resume }
    end
  end

  # GET /resumes/1/edit
  def edit
    @title = 'Личная информация'
    unless current_user.nil?
      @resume = current_user.resume #Resume.find(params[:id])
    else
      redirect_to root_path
    end
    @user = current_user
  end

  def crop
    @resume = current_user.resume    
  end

  # POST /resumes
  # POST /resumes.json
  def create
    @resume = Resume.new(params[:resume])
    current_user.resume = @resume
    respond_to do |format|
      if current_user.save
        if params[:resume][:photo].present?
          logger.debug "==========crop==============="
          render :crop
          logger.debug "==========crop==============="
        else
          format.html { redirect_to current_user, notice: 'Resume was successfully created.' }
          format.json { render json: @resume, status: :created, location: @resume }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /resumes/1
  # PUT /resumes/1.json
  def update    
    @resume = current_user.resume #Resume.find(params[:id]) 

    if @resume.update_attributes(params[:resume]) 

      if params[:resume][:photo].present?
          #return render :json => {:url => @resume.photo.url(:large)}
          render :crop
      else
        redirect_to current_user, notice: 'Resume was successfully updated.'
        #format.html { redirect_to current_user, notice: 'Resume was successfully updated.' }
        #return render :json => {:url => @resume.photo.url(:large)}
      end
    else        
      redirect_to :controller => 'resumes', :action => "crop", :id => current_user.id
      #format.html { render action: "edit" }
       #format.json { render json: @resume.errors, status: :unprocessable_entity }
    end    
  end

  def update_avatar
    @resume = current_user.resume #Resume.find(params[:id]) 

    if @resume.update_attributes(params[:resume])       

      if params[:resume][:photo].present?
        return render :json => {:url => @resume.photo.url(:large)}
        #render :crop
      else
        #redirect_to current_user, notice: 'Resume was successfully updated.'
        #format.html { redirect_to current_user, notice: 'Resume was successfully updated.' }
        
        return render :json => {:url => @resume.photo.url(:small)}
        #return render :json => {:url => compinfo.photo.url}
      end
    else      
      return render :json => {:error => 'Ошибка загрузки фотографии'}
      #redirect_to :controller => 'resumes', :action => "crop", :id => current_user.id
      #format.html { render action: "edit" }
       #format.json { render json: @resume.errors, status: :unprocessable_entity }
    end  
  end

  # DELETE /resumes/1
  # DELETE /resumes/1.json
  def destroy
    @resume = Resume.find(params[:id])
    @resume.destroy

    respond_to do |format|
      format.html { redirect_to resumes_url }
      format.json { head :ok }
    end
  end
end
