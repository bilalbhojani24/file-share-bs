class User < ApplicationRecord
  attr_accessor :login
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :authentication_keys => [:login]
  has_many :documents
  
  validates :name, :email, :username, presence: true
  validates :username, uniqueness: true
  validates_presence_of :password, message: "Password is required", length: { minimum: 8, maximum: 15 }, on: :create
  validates :password, format: { with: /(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*/, message:  "Password must contain atleast one uppercase, lowercase and number"  }, on: :create

  def self.find_for_database_authentication warden_condition
    conditions = warden_condition.dup
    login = conditions.delete(:login)
    where(conditions).where(
      ["lower(username) = :value OR lower(email) = :value",
      { value: login.strip.downcase}]).first
  end
  
end
