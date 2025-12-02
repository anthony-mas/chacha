class CreateCategoryEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :category_events do |t|
      t.references :event, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
