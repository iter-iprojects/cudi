class ProyectostatusesController < ApplicationController
  # GET /proyectostatuses
  # GET /proyectostatuses.xml
  def index
    @proyectostatuses = Proyectostatus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proyectostatuses }
    end
  end

  # GET /proyectostatuses/1
  # GET /proyectostatuses/1.xml
  def show
    @proyectostatus = Proyectostatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proyectostatus }
    end
  end

  # GET /proyectostatuses/new
  # GET /proyectostatuses/new.xml
  def new
    @proyectostatus = Proyectostatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @proyectostatus }
    end
  end

  # GET /proyectostatuses/1/edit
  def edit
    @proyectostatus = Proyectostatus.find(params[:id])
  end

  # POST /proyectostatuses
  # POST /proyectostatuses.xml
  def create

    @proyectostatus = Proyectostatus.new(params[:proyectostatus])           
  
    respond_to do |format|
      if @proyectostatus.save
        format.html { redirect_to(@proyectostatus, :notice => 'Proyectostatus was successfully created.') }
        format.xml  { render :xml => @proyectostatus, :status => :created, :location => @proyectostatus }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @proyectostatus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /proyectostatuses/1
  # PUT /proyectostatuses/1.xml
  def update
    @proyectostatus = Proyectostatus.find(params[:id])

    respond_to do |format|
      if @proyectostatus.update_attributes(params[:proyectostatus])
        format.html { redirect_to(@proyectostatus, :notice => 'Proyectostatus was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @proyectostatus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /proyectostatuses/1
  # DELETE /proyectostatuses/1.xml
  def destroy
    @proyectostatus = Proyectostatus.find(params[:id])
    @proyectostatus.destroy

    respond_to do |format|
      format.html { redirect_to(proyectostatuses_url) }
      format.xml  { head :ok }
    end
  end
end
