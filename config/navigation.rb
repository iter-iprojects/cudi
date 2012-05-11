SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item  :proyectos, 'Inicio', root_path
    primary.item :proyectos, 'Proyectos', proyectos_path do |proyectos|

#      proyectos.item  :proyectos, 'Activos', "http://localhost:3000/ordenby/active"
#      proyectos.item  :proyectos, 'Detenidos', "http://localhost:3000/ordenby/stopped"
#      proyectos.item  :proyectos, 'Finalizados', "http://localhost:3000/ordenby/finish"
#      proyectos.item  :proyectos, 'Eliminados', "http://localhost:3000/ordenby/del"


     # books.item :fiction, 'Fiction', fiction_books_path
     # books.item :history, 'History', history_books_path
     # books.item :sports, 'Sports', sports_books_path
    end
    # proximamente ahora no primary.item :proyectos, 'Proyectos Futuros', futureproyectos_path do |sub_nav_fa|
    # sub_nav_fa.item  :futureproyectos, 'Futuros proyectos', futureproyectos_path
    # sub_nav_fa.item  :futureproyectosactions, 'Acciones futuras', futureproyectosactions_path
    #end

     #primary.item :proyectos, 'Acciones Futuras', actions_path
    
     primary.item  :futureproyectosactions, 'A.futuras', futureproyectosactions_path
     primary.item  :futureproyectos, 'N.futuras', futureproyectos_path
     primary.item  :pictures, 'G.imágenes', pictures_path
     
     primary.item  :cudidocs, 'Docs' , cudidocs_path  
     primary.item  :proyectos, 'P.Control', panelcontrols_path   if can? :update, Panelcontrol
  end
end

