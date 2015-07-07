class AddCourseIdToWishlist < ActiveRecord::Migration
  def change
    add_column :wishlists, :course_id, :integer
  end
end
