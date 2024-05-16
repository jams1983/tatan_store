class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :aasm_state

      t.timestamps
    end

    add_index :carts, :aasm_state
  end
end
