class AddLongitudeToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :longitude, :float
  end
end
