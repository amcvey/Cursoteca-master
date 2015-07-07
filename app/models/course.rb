class Course < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
  ratyrate_rateable "punctuation"
  extend FriendlyId
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :user_wishlists, through: :wishlists, source: :user

  
  friendly_id :title, use: [:slugged, :finders]
  mount_uploader :photo, PhotoUploader

  paginates_per 2
end
