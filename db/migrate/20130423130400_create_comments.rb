class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|

    	## relation
    	t.references :user
    	t.references :post

      t.text :contents
      t.text :author

      t.timestamps
    end
  end
end
