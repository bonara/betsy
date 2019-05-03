class AddColumnToOrderItems < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :cart_id, :integer
  end
end
