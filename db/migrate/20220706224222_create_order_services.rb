class CreateOrderServices < ActiveRecord::Migration[7.0]
  def change
    create_table :order_services do |t|
      t.belongs_to :order, null: false, foreign_key: true
      t.belongs_to :service, null: false, foreign_key: true

      t.timestamps
    end
    add_index :order_services, [:order_id, :service_id], unique:true
  end
end
