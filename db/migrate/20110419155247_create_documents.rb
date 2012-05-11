class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.date :date
      t.string :version
      t.text :changelog
      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
