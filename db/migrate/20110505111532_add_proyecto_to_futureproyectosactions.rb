class AddProyectoToFutureproyectosactions < ActiveRecord::Migration
  def self.up
    add_column :futureproyectosactions, :proyecto, :string
  end

  def self.down
    remove_column :futureproyectosactions, :proyecto
  end
end
