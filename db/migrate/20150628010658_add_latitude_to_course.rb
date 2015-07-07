class AddLatitudeToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :latitude, :float
  end
end
