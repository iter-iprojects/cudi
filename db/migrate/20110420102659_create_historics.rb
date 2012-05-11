class CreateHistorics < ActiveRecord::Migration
  def self.up
    create_table :historics do |t|
      t.string :proyecto
      t.string :document_version

      t.timestamps
    end
  end

  def self.down
    drop_table :historics
  end
end
