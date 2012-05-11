namespace :cudi  do
  desc "setup cudi"
  task :setup => :environment do
    #poner todo lo inicial aquí para un primer arranque


    if  !Proyectostatus.exists?(:name => "activo")
      solve = Proyectostatus.create ({ :name => "activo"}) 
    end

    if  !Proyectostatus.exists?(:name => "borrado_definitivo")
      solve = Proyectostatus.create ({ :name => "borrado_definitivo"})
    end

    if  !Priority.exists?(:name => "alta")
      solve = Priority.create ({ :name => "alta"})
    end

    if  !Priority.exists?(:name => "baja")
      solve = Priority.create ({ :name => "baja"})
    end


    #User.create(:email => 'sample@email.es', :ou => 'admin' ,  :encrypted_password => 'admin' );


=begin
    @user = User.create do |u|
      u.ou = "Admin"
      u.email = "admin@email.com"
      u.encrypted_password = "$2a$10$DUv/IUiLB34jhi3j4Z8MwwcaDlBmFe3rvcdXSzPKLzBOAMmD53UqW"
    end

    @user.save(:validate => false)
=end


    



    if Proyecto.count < 1
      t='Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno en muchasde las industrias desde        1500,' +  
      'cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido     una         de textos y los        de tal manera que       hacer un libro de textos espec' + 
      'imen. No                 500     , sino que tambien         como texto de relleno en documentos             , quedando esencialmente igual al original. Fue popularizado en ' +
      'los 60s con la          de las hojas "Letraset", las cuales contenian pasajes de Lorem Ipsum, y     recientemente con software de            , como por ejemplo Aldus PageMa' + 
      'ker, el cual incluye versiones de Lorem Ipsum.'

      sql = ActiveRecord::Base.connection();
      sql.execute "SET autocommit=0";
      sql.begin_db_transaction
      id, value =
      sql.execute("INSERT INTO proyectos (title,mainresource,priority,status,comments, averange, created_at, updated_at) VALUES ('PROYECTO DEMO','1','1','1','" + t +
                   " ','0','" + DateTime.now.to_s + "','" + DateTime.now.to_s + "'  )" )

      sql.commit_db_transaction
    end

    Resource.create(:controller=>'proyecto', :resource=> '1', :proyecto_id =>  Proyecto.find(:first).id.to_s )

    if !Role.exists?(:name => "administrador")    
      solve = Role.create ({ :name => "administrador"})
    end
   

    if !Roles_user.exists?(:role_id => '1', :user_id => '1')
      Roles_user.create(:role_id=>'1', :user_id=>'1')
    end

  end

end
