class AddNameToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :name, :string
  end
end
