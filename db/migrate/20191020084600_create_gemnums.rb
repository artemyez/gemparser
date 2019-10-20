class CreateGemnums < ActiveRecord::Migration[5.2]
  def change
    create_table :gemnums do |t|
      t.integer :gemnumber
      t.timestamps
    end
  end
end
