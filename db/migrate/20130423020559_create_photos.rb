class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :image
      t.belongs_to :photoable, polymorphic: true

      t.timestamps
    end
    add_index :photos, [:photoable_id, :photoable_type]
  end
end
