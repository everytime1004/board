class CreateGcms < ActiveRecord::Migration
  def change
    create_table :gcms do |t|
      t.string :reg_id
      t.boolean :noty, default: true
      
      ## relation
    	t.references :user

      t.timestamps
    end
  end
end
