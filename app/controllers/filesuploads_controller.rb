class FilesuploadsController < ApplicationController
  
  load_and_authorize_resource

  def index

    @filesuploads = Filesupload.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @filesuploads }
    end

  end



  def show
    @filesupload = Filesupload.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @filesupload }
    end
  end



  def new
    @filesupload = Filesupload.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @filesupload }
    end
  end


  def edit
    @filesupload = Filesupload.find(params[:id])
  end

  
  def create

    @filesupload = filesupload.new(params[:upload])
    if @filesupload.save
      render :json => { :pic_path => @filesupload.picture.url.to_s , :name => @filesupload.picture.instance.attributes["picture_file_name"] }, :content_type => 'text/html'
    else
      render :json => { :result => 'error'}, :content_type => 'text/html'
    end
  end
  

  def update
    @filesupload = Filesupload.find(params[:id])

    respond_to do |format|
      if @filesupload.update_attributes(params[:filesupload])
        format.html { redirect_to(@filesupload, :notice => 'Filesupload was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @filesupload.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @filesupload = Filesupload.find(params[:id])
    @filesupload.destroy

    respond_to do |format|
      format.html { redirect_to(filesuploads_url) }
      format.xml  { head :ok }
    end
  end
end
