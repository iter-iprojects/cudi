class CreateProyectostatuses < ActiveRecord::Migration
  def self.up
    create_table :proyectostatuses do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :proyectostatuses
  end
end
