class Order < ApplicationRecord
    add_column :orders, :email, :string
    add_column :orders, :address, :string
    add_column :orders, :name, :string
    add_column :orders, :cc_name, :string
    add_column :orders, :cc_exp, :date
    add_column :orders, :cc_num, :integer
end
