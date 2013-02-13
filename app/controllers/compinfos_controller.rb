# -*- encoding : utf-8 -*-
class CompinfosController < ApplicationController
  # GET /compinfos
  # GET /compinfos.json

  def index

    @compinfos = Compinfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @compinfos }
    end
  end

  def crop
    @compinfo = current_user.compinfo
  end

  # GET /compinfos/1
  # GET /compinfos/1.json
  def show
    @title = "Информация о компании"
    @compinfo = Compinfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @compinfo }
    end
  end

  # GET /compinfos/new
  # GET /compinfos/new.json
  def new
    @compinfo = Compinfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @compinfo }
    end
  end

  # GET /compinfos/1/edit
  def edit
    @compinfo = User.find(current_user).compinfo
  end

  # POST /compinfos
  # POST /compinfos.json
  def create
    @compinfo = Compinfo.new(params[:compinfo])
    current_user.compinfo = @compinfo
    respond_to do |format|
      if current_user.save
        format.html { redirect_to current_user, notice: 'Информация успешно заполнена. Благодарим Вас за регистрацию.' }
        format.json { render json: @compinfo, status: :created, location: @compinfo }
      else
        format.html { render action: "new" }
        format.json { render json: @compinfo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /compinfos/1
  # PUT /compinfos/1.json
  def update
    @compinfo = current_user.compinfo
    
    if @compinfo.update_attributes(params[:compinfo])        
      if params[:compinfo][:photo].present?
        render :crop
      else                     
        redirect_to @current_user, notice: 'Resume was successfully updated.'        
      end
    else
      redirect_to :controller => 'compinfos', :action => "crop", :id => current_user.id
      #format.html { render action: "edit" }
      #format.json { render json: @compinfo.errors, status: :unprocessable_entity }
    end    
  end

  def update_avatar_comp
    @compinfo = current_user.compinfo #Resume.find(params[:id]) 
    
    if @compinfo.update_attributes(params[:compinfo]) 

      if params[:compinfo][:photo].present?        
        return render :json => {:url => @compinfo.photo.url(:large)}
        #render :crop
      else
        #redirect_to current_user, notice: 'Resume was successfully updated.'
        #format.html { redirect_to current_user, notice: 'Resume was successfully updated.' }
        
        return render :json => {:url => @compinfo.photo.url(:thumb)}
        #return render :json => {:url => compinfo.photo.url}
      end
    else      
      return render :json => {:error => 'Ошибка загрузки фотографии'}
      #redirect_to :controller => 'resumes', :action => "crop", :id => current_user.id
      #format.html { render action: "edit" }
       #format.json { render json: @resume.errors, status: :unprocessable_entity }
    end  
  end

  # DELETE /compinfos/1
  # DELETE /compinfos/1.json
  def destroy
    @compinfo = Compinfo.find(params[:id])
    @compinfo.destroy

    respond_to do |format|
      format.html { redirect_to compinfos_url }
      format.json { head :ok }
    end
  end
end
