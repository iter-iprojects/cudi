class Futureproyectosaction < ActiveRecord::Base
  belongs_to  :proyecto
  has_many   :resource, :foreign_key => :proyecto_id, :conditions => {:controller=> 'futureproyectosaction'}
  validates_associated :proyecto

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
      self.comments += 'Demasiadas lineas, max 50'
    end


    if self.comments.split.size > 500 
      c=1
      a=''
      self.comments.split.each do |e|
        a += self.comments[e] + ' ' if c < 500
        c += 1
      end
      self.comments = '<div>' + a + '<div id="toomuchtext">Too much text, it\'s limited 500 words</div>'  + '</div>'
    end


    html = self.comments

    config = {
              :elements   => ['table','td','tr','img','p','strong','pagebreak','em','span','h1','h2','hr','pre','blockquote'],
              :attributes => {'table' => ['class','style'], 'td' => [], 'tr' => [], 'img' => ['css','src','alt','style','width','height'],
                              'p' => ['style'], 'h1' => ['style'], 'h2' => ['style'], 'span' => ['style'] },
              :protocols  => {'class' => 'tinypersonalclasstable'}
    }

    self.comments= Sanitize.clean(html, config)
    self.comments = self.comments.gsub("<div>pagebreakchangenow</div>", "<p><!-- pagebreak --></p>")
  end
end
