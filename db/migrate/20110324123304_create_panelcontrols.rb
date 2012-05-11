class CreatePanelcontrols < ActiveRecord::Migration
  def self.up
    create_table :panelcontrols do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :panelcontrols
  end
end
