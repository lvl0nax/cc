class GrantsController < ApplicationController
  # GET /grants
  # GET /grants.json
  def index
    @grants = Grant.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @grants }
    end
  end

  # GET /grants/1
  # GET /grants/1.json
  def show
    @grant = Grant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @grant }
    end
  end

  # GET /grants/new
  # GET /grants/new.json
  def new
    @grant = Grant.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @grant }
    end
  end

  # GET /grants/1/edit
  def edit
    @grant = Grant.find(params[:id])
  end

  # POST /grants
  # POST /grants.json
  def create
    @grant = Grant.new(params[:grant])

    respond_to do |format|
      if @grant.save
        format.html { redirect_to @grant, notice: 'Grant was successfully created.' }
        format.json { render json: @grant, status: :created, location: @grant }
      else
        format.html { render action: "new" }
        format.json { render json: @grant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /grants/1
  # PUT /grants/1.json
  def update
    @grant = Grant.find(params[:id])

    respond_to do |format|
      if @grant.update_attributes(params[:grant])
        format.html { redirect_to @grant, notice: 'Grant was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @grant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grants/1
  # DELETE /grants/1.json
  def destroy
    @grant = Grant.find(params[:id])
    @grant.destroy

    respond_to do |format|
      format.html { redirect_to grants_url }
      format.json { head :ok }
    end
  end
end
