Cudi::Application.routes.draw do

  resources :cudidocs
  resources :pictures
  resources :filesuploads
    #resources :proyectos do
   resources :photos, :only => [:create, :destroy]
  #end

  #devise_for :users
 # devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'register', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock' }  
  #devise_for :users ,:controllers => { :registrations => "users/registrations" }
  #devise_for :users, :controllers => { :sessions => :sessions }
  #devise_for :users
  
  #devise_for :users,  :controllers => { :confirmations => "confirmations" }
  
  #devise_for :users

devise_for :users, :controllers => { 
    :omniauth_callbacks => "users/omniauth_callbacks", 
    #:registrations => 'registrations', 
    :passwords => 'passwords' 
   # :sessions => 'sessions#create'
    #:confirmations => 'confirmations' 
} do
  #match 'confirmations/unconfirmed' => 'confirmations#unconfirmed', :as => :unconfirmed
  #match 'users/confirmations/:id' => 'devise/confirmations#show', :as => :confirmations
  post '/users/sign_in' => 'sessions#create' 
  get  '/users/sign_out' => 'devise/sessions#destroy' 
  get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
end

  
  resources :users

  #resources :confirmations  

  resources :priorities

  resources :resources
  
  resources :proyectostatuses

  resources :historics

  resources :documents

  #resources :futureproyectosactions

#  resources :futureproyectos

  #resources :panelcontrols

  resources :uploads


  resources :panelcontrols, :path_names => { :update => 'updateroles' } 

#  match 'createdocument' => 'panelcontrols#create_document'

	
  
  #resources :proyectos

#match "create_histo", :action  => "create_histo", :controller => "proyectos"  
 
# match "createdocument", :action  => "create_document", :controller => "panelcontrols"  

  resources :panelcontrols,:only => [:generate_document] do
     collection do
       post "generate_document"
     end
   end







  #resources :proyectos,:only => [:index] do
  resources :proyectos,:only => [:index] do
     collection do
       #get "post_data"
       post "post_data"
     end
   end

  resources :proyectos,:only => [:editresources] do
     collection do
       post "editresources"
     end
   end

  resources :proyectos,:only => [:getresources] do
     collection do
       get "getresources"
      # post "postresources"
     end
    end 

  

  resources :proyectos,:only => [:new] do
     collection do
     end
   end


  resources :proyectos,:only => [:setg] do
     collection do
       post "setg"
     end
  end
   
   
  resources :proyectos,:only => [:udateFromTinymce] do
     collection do
       post "udateFromTinymce"
     end
  end
   

   

  resources :proyectos,:only => [:list_proyect_iphone] do
     collection do
       post "list_proyect_iphone"
     end
   end
   
   

 

  resources :proyectos,:only => [:mobile_new_proyecto] do
     collection do
       get "mobile_new_proyecto"
       post "mobile_new_proyecto"
     end
   end
   


  resources :futureproyectos,:only => [:index] do
     collection do
       post "post_data_futureproyectos"
     end
   end
  
=begin
  resources :futureproyectos,:only => [:editresources] do
     collection do
       post "post_data_futureproyectosedit"
     end
  end
=end  

 
   
     resources :futureproyectosactions,:only => [:setg] do
     collection do
       post "setg"
     end
   end




  resources :proyectos,:only => [:pickupfile] do
     collection do
       post "pickupfile"
       #get "pickup_file"
       #put "pickup_file"
     end
   end
   

   

  resources :futureproyectosactions,:only => [:index] do
     collection do
       post "post_data_futureproyectosactions"
     end
   end
   
   
   resources :futureproyectosactions,:only => [:udateFromTinymce] do
     collection do
       post "udateFromTinymce"
     end
    end
    
      resources :futureproyectosactions,:only => [:getresources] do
     collection do
       get "getresources"
      # post "postresources"
     end
    end 


   resources :cudidocs,:only => [:datasheetsave] do
     collection do
       post "datasheetsave"
     end
    end

   resources :cudidocs,:only => [:getHtml] do
     collection do
       post "getHtml"
     end
    end



   resources :cudidocs,:only => [:updatetitles] do
     collection do
       post "updatetitles"
     end
    end
    
    resources :cudidocs,:only => [:getalldocs] do
     collection do
       post "getalldocs"
     end
    end
    
    
    
    resources :cudidocs,:only => [:getallpublicdocs] do
     collection do
       post "getallpublicdocs"
     end
    end
    
    
    
    
       resources :cudidocs,:only => [:erasedocs] do
     collection do
       post "erasedocs"
     end
    end
    
     resources :cudidocs,:only => [:publicdocs] do
     collection do
       post "publicdocs"
     end
    end
    
     resources :cudidocs,:only => [:sendpdf] do
     collection do
       post "sendpdf"
     end
    end    
    
    
     resources :cudidocs,:only => [:enduserspreeadsheet] do
     collection do
       post "enduserspreeadsheet"
     end
    end   
     
    
    
    
    
    resources :users,:only => [:usersonline] do
         collection do
       post "usersonline"
     end
    end  
    
    
    
    



#  resources :proyectos,:only => [:getresources] do
#     collection do
#       get "getresources"
#     end
#   end

  #match "proyectos/status/:status_id" => "proyectos#index"
  
   match "listpdffiles" => "home#listpdffiles"
   match "showpdf" => "home#showpdf"
   
   match "cudidocs/getHtml/:docid" => "cudidocs#getHtml" 
   
   match "cudidocs/updatetitles/:noid" => "cudidocs#updatetitles"

  
  
  match "publicproyecto/:proyectotitle" => "publicproyecto#index" 
  
 
  
  match "sendpdftousers" => "panelcontrols#sendpdftousers"  
  match "create_pdf" => "panelcontrols#create_pdf" 
  match "proyectos/status/:status_id/resource/:resource_id" => "proyectos#index"
  match "futureproyectosactions/status/:status_id/resource/:resource_id" => "futureproyectosactions#index"
  
 
  #match "proyectos/getresources"  => "proyectos#getresources" 
  match "futureproyectos/getresources"  => "futureproyectos#getresources"
  #match "futureproyectosactions/getresources"  => "futureproyectosactions#getresources"
  match "proyectos/publicos/:parent_id"  => "proyectos#proyectourl"
  match "proyectos/editresources/:parent_id"  => "proyectos#editresources"
  match "futureproyectos/editresources"  => "futureproyectos#editresources"
  match "futureproyectosactions/editresources"  => "futureproyectosactions#editresources"


  
  match "confirm/:token/:user_id/:user_token" => "panelcontrols#confirm_token"
 
  match "inlinepdf/users_confirm"  =>  "panelcontrols#usersconfirmpdf"

 # match "confirmations/:id?confirmation_token=:confirmation_token"   => "users/confirmations#validateuser"



 
   #  match "proyectos/ordenby/:listby"  => "proyectos#index" 


       #match "proyectos/ordenby/:listby"  => "proyectos#index", :as => 'listby'

    # resources :proyectos do	       
       #   get 'recent'

=begin
       match "proyectos/ordenby/:listby"  => "index", :controller => "proyectos"  
         member do
         get 'index'
         post 'index'
       end
=end 
 
 
 
   #    collection do
 #       get 'ordenbyg', :action => 'index' 
#	match "proyectos/ordenby/:listby"  => "index"   
    #   end
   #  end


  
#/products/:id(.:format)                    {:controller=>"catalog", :action=>"view"}


  resources :roles

  resources :roles_users


# replace devise_for :users with:
#devise_for :users,  :controllers => { :registrations => "users/registrations" }
#devise_for :users,  :controllers => { :registrations => "users/registrations", :confirmations => "users/confirmations" }
#devise_for :users,  :controllers => { :registrations => "users/registrations" }



root :to => "home#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
