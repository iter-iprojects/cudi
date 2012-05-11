# encoding: UTF-8
class Proyecto < ActiveRecord::Base

  has_one  :Priority 
  has_one :Proyectostatuses
  has_many   :photos,  :dependent => :destroy
  has_many  :futureproyectosaction , :foreign_key => :proyecto_id  
  has_many  :resource,  :conditions => {:controller => 'proyecto'}


  belongs_to :user
  validates_presence_of :title, :on => :create, :message => "can't be blank"

  has_attached_file :photo,
  :styles => {
    :thumb=> "100x100#",
    :small  => "150x150>",
    :medium => "300x300>",
    :large =>   "400x400>",
    :path => ":rails_root/public/imgtmp/",
    :url => ":rails_root/public/imgtmp/"
  }
 
  before_save :formattable
  before_create :formattable
    
    
  def formattable
    return nil if self.comments == ''
    return nil if !self.comments 
    self.comments = self.comments.gsub("<div", "<p")
    self.comments = self.comments.gsub("<\/div", "</p") 
    
    require 'sanitize'      
    self.comments = self.comments.gsub("<p><!-- pagebreak --></p>", "<div>pagebreakchangenow</div>")

    if self.comments.lines.to_s >= '50'.to_s   

    c=1  
    self.comments.lines.each do |l|
      if c > 50
        self.comments[l]='' 
      end 
      c += 1
    end
    self.comments += 'Too much lines, max 50'
  end

      
  if self.comments.split.size > 500
    c=1
    a=''
    self.comments.split.each do |e|            
      a += self.comments[e] + ' ' if c < 500
      c += 1
    end  
    self.comments = '<div>' + a + '<div id="toomuchtext">Text too long, max   500 words</div>'  + '</div>'
  end
 


  allowed_elements = ['table', 'td', 'tr', 'h2', 'a', 'img', 'p', 'ul', 'ol', 'li', 'strong', 'em', 'cite', 'blockquote', 'code', 'pre', 'dl', 'dt', 'dd', 'br', 'hr', 'sup', 'div']
  allowed_attributes = {'table' => ['class','style'], 'a' => ['href', 'rel', 'rev'], 'img' => ['src', 'alt'], 'sup' => ['id'], 'div' => ['class'], 'li' => ['id']}
  allowed_protocols = {'a' => {'href' => ['http', 'https', 'mailto', :relative]}}


  self.comments  = Sanitize.clean(self.comments, :elements => allowed_elements, :attributes => allowed_attributes, :protocols => allowed_protocols)
  self.comments = self.comments.gsub("<div>pagebreakchangenow</div>", "<p><!-- pagebreak --></p>")

  end
 
  has_many :resource, :foreign_key => "proyectoid" 
  validates :title, :presence => {:message => 'Title yeaa cannot be blank, Task not saved'}

  #serialize :resources
  acts_as_list
  
  after_create :create_pdf


  def create_pdf
    @proyectosi = Proyecto.all
    File.delete('public/pdf/allproyects.pdf') if File.file?( 'public/pdf/allproyects.pdf' )
    s=''
    @proyectosi.each do |v|
      mas=v.resources
      du=''

      mas.each{|nv|                   
        @ud = User.find_by_id(nv)
        du += ', ' +  @ud['email'] if User.find_by_id(nv)		 
      }
	
      s += '<tr><td>' + v.id.to_s + '</td><td>'+ v.title.to_s + '</td><td>' + v.priority.to_s + '</td><td>responsable</td><td>' 
      + du.to_s + '</td><td>' + v.status.to_s + '</td><td>' + v.comments.to_s + '</td><td>' + v.actions.to_s + '</td><td></tr>'
    end

    h='
      <table class="proyectosTable">
        <tr>
          <th id="numero" title="Numero">N</th>
          <th id="proyecto" title="Proyecto">Proyecto</th>
          <th id="prioridad" title="Prioridad">Prioridad</th>
          <th id="responsable" title="Responsable">Responsable</th>
          <th id="recursos" title="Recursos humanos">Recursos</th>
          <th id="estado" title="Estado" >Estado</th>
          <th id="comentarios" title="Comentarios">Comentarios</th>
          <th id="acciones" title="Acciones">Acciones</th>
        </tr>'
    f='</table>'

    kit = PDFKit.new(h + s + f)
    kit.stylesheets << 'public/stylesheets/proyecto.css'

    kit.to_file('public/pdf/allproyects.pdf')
    @user = User.all
    @user.each do |v|
      UserMailer.send_pdf(v.email.to_s, h + s + f).deliver		    
    end
  end

  def join_status
    Proyecto.joins(:proyectostatuses) 
  end

end
