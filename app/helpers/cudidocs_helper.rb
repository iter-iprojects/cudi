module CudidocsHelper
  
def listmisdoc
  cudidoc=''
  cudidoc = Cudidoc.where(:user_id => current_user.id)
end  

def getHtml(id)
  cudidoc=''
  cudidoc = Cudidoc.find(id).contain
end  
  
end
