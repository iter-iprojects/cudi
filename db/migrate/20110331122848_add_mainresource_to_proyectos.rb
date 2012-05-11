class AddMainresourceToProyectos < ActiveRecord::Migration
  def self.up
    add_column :proyectos, :mainresource, :string
  end

  def self.down
    remove_column :proyectos, :mainresource
  end
end
