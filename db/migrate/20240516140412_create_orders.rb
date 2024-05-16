class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.decimal :shipping_total, precision: 10, scale: 2, null: false
      t.decimal :total, precision: 10, scale: 2, null: false
      t.references :cart, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
