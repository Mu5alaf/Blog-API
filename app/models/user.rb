class User < ApplicationRecord
    # validation
    has_secure_password
    # relation with post and comments
    has_many :posts , dependent: :destroy
    has_many :comments , dependent: :destroy
    validates :email, presence: true, uniqueness: true
end
