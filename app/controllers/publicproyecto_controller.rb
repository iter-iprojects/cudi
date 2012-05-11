class PublicproyectoController < ApplicationController

  skip_before_filter :authenticate_user!

  def index
    @publicproyectode=Proyecto.find(:first, :conditions=>{:title=>params[:proyectotitle]})
    if p  
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @publicproyectode }
      end
    end
  end   
 
end
