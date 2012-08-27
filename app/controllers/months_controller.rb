class MonthsController < ApplicationController
  # GET /months
  # GET /months.json
  def index
    @months = Month.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @months }
    end
  end

  # GET /months/1
  # GET /months/1.json
  def show
    @month = Month.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @month }
    end
  end

  # GET /months/new
  # GET /months/new.json
  def new
    @month = Month.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @month }
    end
  end

  # GET /months/1/edit
  def edit
    @month = Month.find(params[:id])
  end

  # POST /months
  # POST /months.json
  def create
    @month = Month.new(params[:month])

    respond_to do |format|
      if @month.save
        format.html { redirect_to months_url, notice: 'Month was successfully created.' }
        format.json { render json: @month, status: :created, location: @month }
      else
        format.html { render action: "new" }
        format.json { render json: @month.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /months/1
  # PUT /months/1.json
  def update
    @month = Month.find(params[:id])

    respond_to do |format|
      if @month.update_attributes(params[:month])
        format.html { redirect_to @month, notice: 'Month was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @month.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /months/1
  # DELETE /months/1.json
  def destroy
    @month = Month.find(params[:id])
    @month.destroy

    respond_to do |format|
      format.html { redirect_to months_url }
      format.json { head :ok }
    end
  end
end
