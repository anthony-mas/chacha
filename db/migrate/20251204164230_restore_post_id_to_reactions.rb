class RestorePostIdToReactions < ActiveRecord::Migration[7.1]
  def change
    remove_index :reactions, name: "index_reactions_on_reactable"
    remove_column :reactions, :reactable_type
    remove_column :reactions, :reactable_id

    add_reference :reactions, :post, null: false, foreign_key: true
  end
end
