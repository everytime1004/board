class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|

    	## relation
    	t.references :user

    	## contents
      t.string :title
      t.text :description
      t.string :category
      t.integer :count, default: 0

      t.timestamps
    end
  end
end
