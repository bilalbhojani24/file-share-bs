class User < ApplicationRecord
    has_many :documents
    validates_presence_of :name, message: "Name is required"
    validates_presence_of :email, message: "Email is required"
    validates_presence_of :username, message: "Username is required"
    validates :username, uniqueness: {message: "Username is already taken!"}
    validates :password_digest, presence: true
    has_secure_password
end
