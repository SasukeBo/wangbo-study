class User < ActiveRecord::Base
  phonereg = /\^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\d{8}\$/

  has_many :articles, dependent: :destroy
  validates :nick_name, presence: true
  validates :username, presence: true, 
    length: { minimum: 5, maximum: 20 },
    uniqueness: true
  validates :password, presence: true,
    length: {minimum: 6}
  validates :email, presence: true,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: true
  validates :phone_num, presence: true,
    uniqueness: true, length: { is: 11 }, format: { with: phonereg }
  has_secure_password

end
