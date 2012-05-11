class HistoricsController < ApplicationController
  # GET /historics
  # GET /historics.xml
  def index
    @historics = Historic.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @historics }
    end
  end

  # GET /historics/1
  # GET /historics/1.xml
  def show
    @historic = Historic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @historic }
    end
  end

  # GET /historics/new
  # GET /historics/new.xml
  def new
    @historic = Historic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @historic }
    end
  end

  # GET /historics/1/edit
  def edit
    @historic = Historic.find(params[:id])
  end

  # POST /historics
  # POST /historics.xml
  def create
    @historic = Historic.new(params[:historic])

    respond_to do |format|
      if @historic.save
        format.html { redirect_to(@historic, :notice => 'Historic was successfully created.') }
        format.xml  { render :xml => @historic, :status => :created, :location => @historic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @historic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /historics/1
  # PUT /historics/1.xml
  def update
    @historic = Historic.find(params[:id])

    respond_to do |format|
      if @historic.update_attributes(params[:historic])
        format.html { redirect_to(@historic, :notice => 'Historic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @historic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /historics/1
  # DELETE /historics/1.xml
  def destroy
    @historic = Historic.find(params[:id])
    @historic.destroy

    respond_to do |format|
      format.html { redirect_to(historics_url) }
      format.xml  { head :ok }
    end
  end
end
