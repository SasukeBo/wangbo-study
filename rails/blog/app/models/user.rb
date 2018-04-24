class User < ActiveRecord::Base
  attr_accessor :remember_token
  has_many :articles, dependent: :destroy
  validates :nick_name, presence: true
  validates :username, presence: true, 
    length: { minimum: 5, maximum: 20 },
    uniqueness: true
  validates :password, presence: true,
    length: {minimum: 6}
  validates :email, presence: true,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: { case_sensitive: false }
  validates :phone_num, presence: true,
    uniqueness: true, length: { is: 11 }, format: { with: /\A(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\d{8}\z/}
  has_secure_password

  # 返回指定字符串的哈希摘要
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 为了持久会话，在数据库中记住用户。
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(:remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
