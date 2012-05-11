class PicturesController < ApplicationController

  def index
    @pictures = Picture.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pictures }
    end
  end

  def show
    @picture = Picture.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @picture }
    end
  end

  def new
    @picture = Picture.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @picture }
    end
  end

  def edit
    @picture = Picture.find(params[:id])
  end

  def create
    @picture = Picture.new(params[:picture])
    respond_to do |format|
      if @picture.save
        format.html { redirect_to(@picture, :notice => 'Picture was successfully created.') }
        format.xml  { render :xml => @picture, :status => :created, :location => @picture }
        format.json {  render :json => { :pic_path => @picture.file.url(:thumb).to_s, :name => @picture.file.filename }, 
                                         :content_type => 'text/html'
                    }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @picture.errors, :status => :unprocessable_entity }
        format.json { render :json => { :result => 'error'}, 
                             :content_type => 'text/html'
                    }
      end
    end
  end

  def update
    @picture = Picture.find(params[:id])

    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        format.html { redirect_to(@picture, :notice => 'Picture was successfully updated.') }
        format.xml  { head :ok }
        format.json {  render :json => { :pic_path => @picture.file.url(:thumb).to_s, :name => @picture.file.filename }, 
                              :content_type => 'text/html'
                    }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @picture.errors, :status => :unprocessable_entity }
        format.json { render :json => { :result => 'error'}, 
                             :content_type => 'text/html'
                    }
      end
    end
  end


  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to(pictures_url) }
      format.xml  { head :ok }
    end
  end
end
