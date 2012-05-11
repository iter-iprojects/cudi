class AddProyectoIdToResources < ActiveRecord::Migration
  def self.up
    add_column :resources, :proyecto_id, :string
  end

  def self.down
    remove_column :resources, :proyecto_id
  end
end
