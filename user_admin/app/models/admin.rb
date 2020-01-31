class Admin < ApplicationRecord
    validates :name, presence: true, length: { minimum: 3}
    validates :username, uniqueness: true, presence:true, length: { minimum: 3}
    validates :password, presence: true,  length: { minimum: 6}
end
