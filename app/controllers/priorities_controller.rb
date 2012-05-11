class PrioritiesController < ApplicationController
   load_and_authorize_resource
  # GET /priorities
  # GET /priorities.xml
  def index
    @priorities = Priority.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @priorities }
    end
  end

  # GET /priorities/1
  # GET /priorities/1.xml
  def show
    @priority = Priority.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @priority }
    end
  end

  # GET /priorities/new
  # GET /priorities/new.xml
  def new
    @priority = Priority.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @priority }
    end
  end

  # GET /priorities/1/edit
  def edit
    @priority = Priority.find(params[:id])
  end

  # POST /priorities
  # POST /priorities.xml
  def create
    @priority = Priority.new(params[:priority])

    respond_to do |format|
      if @priority.save
        format.html { redirect_to(@priority, :notice => 'Priority was successfully created.') }
        format.xml  { render :xml => @priority, :status => :created, :location => @priority }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @priority.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /priorities/1
  # PUT /priorities/1.xml
  def update
    @priority = Priority.find(params[:id])

    respond_to do |format|
      if @priority.update_attributes(params[:priority])
        format.html { redirect_to(@priority, :notice => 'Priority was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @priority.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /priorities/1
  # DELETE /priorities/1.xml
  def destroy
    @priority = Priority.find(params[:id])
    @priority.destroy

    respond_to do |format|
      format.html { redirect_to(priorities_url) }
      format.xml  { head :ok }
    end
  end
end
