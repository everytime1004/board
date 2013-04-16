class CreateGcms < ActiveRecord::Migration
  def change
    create_table :gcms do |t|
      t.string :reg_id

      t.timestamps
    end
  end
end
