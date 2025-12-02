# Migration - cree la table chachas
class CreateChachas < ActiveRecord::Migration[7.1]
  def change
    create_table :chachas do |t|
      t.string :name # Nom du chacha
      t.timestamps   # created_at, updated_at
    end
  end
end
