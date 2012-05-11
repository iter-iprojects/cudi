class CreateFutureproyectosactions < ActiveRecord::Migration
  def self.up
    create_table :futureproyectosactions do |t|
      t.string :title
      t.string :comments
      t.string :resources
      t.string :mainresource
      t.string :priority
      t.string :proyecto_id
      t.timestamps
    end
  end

  def self.down
    drop_table :futureproyectosactions
  end
end
