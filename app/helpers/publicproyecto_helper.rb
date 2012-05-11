module PublicproyectoHelper
=begin
  def listproyecto
    @proyecto=Proyecto.find(:all).title    
    @proyecto.each do |p|      
    end
  end
=end
end
