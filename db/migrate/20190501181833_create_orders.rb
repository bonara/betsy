class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :email
      t.string :address
      t.string :name
      t.string :cc_name
      t.date :cc_exp
      t.integer :cc_num

      t.timestamps
    end
  end
end
