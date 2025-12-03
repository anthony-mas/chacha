class AddExtraGuestsToParticipations < ActiveRecord::Migration[7.1]
  def change
    add_column :participations, :extra_guests, :integer, default: 0
  end
end
