class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :price
      t.integer :quantity
      t.belongs_to :seller

      t.timestamps
    end
  end
end
