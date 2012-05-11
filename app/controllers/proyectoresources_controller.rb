class ProyectoresourcesController < ApplicationController
  # GET /proyectoresources
  # GET /proyectoresources.xml
  def index
    @proyectoresources = Proyectoresource.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proyectoresources }
    end
  end

  # GET /proyectoresources/1
  # GET /proyectoresources/1.xml
  def show
    @proyectoresource = Proyectoresource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proyectoresource }
    end
  end

  # GET /proyectoresources/new
  # GET /proyectoresources/new.xml
  def new
    @proyectoresource = Proyectoresource.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @proyectoresource }
    end
  end

  # GET /proyectoresources/1/edit
  def edit
    @proyectoresource = Proyectoresource.find(params[:id])
  end

  # POST /proyectoresources
  # POST /proyectoresources.xml
  def create
    @proyectoresource = Proyectoresource.new(params[:proyectoresource])

    respond_to do |format|
      if @proyectoresource.save
        format.html { redirect_to(@proyectoresource, :notice => 'Proyectoresource was successfully created.') }
        format.xml  { render :xml => @proyectoresource, :status => :created, :location => @proyectoresource }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @proyectoresource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /proyectoresources/1
  # PUT /proyectoresources/1.xml
  def update
    @proyectoresource = Proyectoresource.find(params[:id])

    respond_to do |format|
      if @proyectoresource.update_attributes(params[:proyectoresource])
        format.html { redirect_to(@proyectoresource, :notice => 'Proyectoresource was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @proyectoresource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /proyectoresources/1
  # DELETE /proyectoresources/1.xml
  def destroy
    @proyectoresource = Proyectoresource.find(params[:id])
    @proyectoresource.destroy

    respond_to do |format|
      format.html { redirect_to(proyectoresources_url) }
      format.xml  { head :ok }
    end
  end
end
