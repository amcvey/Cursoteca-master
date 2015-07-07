class User < ActiveRecord::Base
  ratyrate_rater
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  validates :name, presence: true

  has_many :courses, dependent: :destroy
  has_many :wishlists, dependent: :destroy


  enum role: [:guest, :client, :admin]

  before_save :default_values

  def default_values
    self.role ||= 0
  end

end
