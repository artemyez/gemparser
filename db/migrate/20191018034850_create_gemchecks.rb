class CreateGemchecks < ActiveRecord::Migration[5.2]
  def change
    create_table :gemchecks do |t|
      t.date   :date
      t.string :rubygem
      t.string :title
      t.string :cve
      t.timestamps
    end
  end
end
