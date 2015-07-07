class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :photo
      t.string :title
      t.string :place
      t.text :description
      t.integer :punctuation
      t.integer :price
      t.string :category

      t.timestamps null: false
    end
  end
end
