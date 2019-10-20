class ChangeDateColomnType < ActiveRecord::Migration[5.2]
  def change
    change_column :gemchecks, :date, :string
  end
end
