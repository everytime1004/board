class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|

    	## relation
      t.belongs_to :postable, polymorphic: true
      t.references :user

    	## contents
      t.string :title
      t.text :description
      t.string :category
      t.integer :count, default: 0
      t.string :author

      t.timestamps
    end
    add_index :posts, [:postable_id, :postable_type]
  end
end
