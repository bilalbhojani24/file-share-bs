class User < ApplicationRecord
    has_many :documents
    validates :name, :email ,presence: true
    validates :username, presence: true, uniqueness: {message: "Username is already taken!"}
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
    validates :password_digest, presence: true
    has_secure_password
end
