class CreateExecutors < ActiveRecord::Migration[7.0]
  def change
    create_table :executors do |t|
      t.string :name
      t.string :second_name

      t.timestamps
    end
  end
end
