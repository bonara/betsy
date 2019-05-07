class RemoveColumnVisible < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :visible
  end
end
