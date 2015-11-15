class AddBaseTypeToBase < ActiveRecord::Migration
  def change
    add_reference :bases, :base_type, index: true
    add_foreign_key :bases, :base_types
  end
end
