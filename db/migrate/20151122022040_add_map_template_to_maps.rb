class AddMapTemplateToMaps < ActiveRecord::Migration
  def change
    add_column :maps, :map_template, :text
  end
end
