include EmailValidatable
class User < ApplicationRecord
    validates :name, presence: true, length: { minimum: 3}
    validates :email, email:true, presence:true
    validates :phone, presence: true, length: { minimum: 10, maximum: 10}
    validates :password, presence: true, length: { minimum: 6}
end
