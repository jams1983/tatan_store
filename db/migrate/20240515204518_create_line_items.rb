class CreateLineItems < ActiveRecord::Migration[7.1]
  def change
    create_table :line_items, id: :uuid do |t|
      t.references :product, null: false, foreign_key: true, type: :uuid
      t.references :cart, null: false, foreign_key: true, type: :uuid
      t.integer :amount

      t.timestamps
    end
  end
end
