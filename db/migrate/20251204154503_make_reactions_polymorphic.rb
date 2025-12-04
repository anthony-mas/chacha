class MakeReactionsPolymorphic < ActiveRecord::Migration[7.1]
  def change
    remove_reference :reactions, :post, foreign_key: true

    add_reference :reactions, :reactable, polymorphic: true, null: false

    add_index :reactions, [:reactable_type, :reactable_id]
  end
end
