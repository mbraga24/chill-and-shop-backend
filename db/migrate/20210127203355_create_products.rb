class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title
      t.float :price
      t.string :image_url
      t.integer :quantity
      t.references :seller

      t.timestamps
    end
  end
end
