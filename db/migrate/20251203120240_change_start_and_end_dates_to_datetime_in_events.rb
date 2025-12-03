class ChangeStartAndEndDatesToDatetimeInEvents < ActiveRecord::Migration[7.1]
  def change
    change_column :events, :starts_on, :datetime
    change_column :events, :ends_on, :datetime
  end
end
