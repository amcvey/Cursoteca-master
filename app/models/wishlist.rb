class Wishlist < ActiveRecord::Base
  belongs_to :user
  has_many :courses, dependent: :destroy
  # has_many :courses, :through => :wishlist_courses
end
