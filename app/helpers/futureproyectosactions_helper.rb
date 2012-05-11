module FutureproyectosactionsHelper
  
  def list_proa
    pr = Hash.new
    pro = Proyecto.find(:all)
    pro.each do |r|
      pr[r.id] = r.title
    end
    return  pr
  end  
  
  def allfutureproyectosassociations  
    Proyecto.find(:all, :include => :futureproyectosaction)
  end
  
  
end
