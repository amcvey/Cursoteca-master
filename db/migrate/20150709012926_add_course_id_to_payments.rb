class AddCourseIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :course_id, :string
  end
end
