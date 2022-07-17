class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.belongs_to :executor, null: false, foreign_key: true
      t.integer :cost, null: true, default: 0

      t.timestamps
    end
  end
end
