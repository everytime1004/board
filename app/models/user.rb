# encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :tel, :password, :password_confirmation, :remember_me, :phone_first, :phone_second, :phone_third, :phone
  # attr_accessible :title, :body

  validates_numericality_of :phone_second, :only_integer => true, presence: false, allow_blank: true
  validates_numericality_of :phone_third, :only_integer => true, presence: false, allow_blank: true

  validates_format_of :name, :with => /^[^!@#\$%\^\&\*\(\)\+\_\-\?\<\>:"';\.\,\`\/\|\\\~\ _]*$/, message: "유효하지 않는 이름입니다. 특수문자를 빼주세요."
  validates :name, :length => { :in => 3..13 }, uniqueness: true

  has_many :posts, as: :postable, dependent: :destroy
  has_many :comments, dependent: :destroy

  before_save :ensure_authentication_token, :combine_phone

  def combine_phone
    self.phone = phone_first + phone_second + phone_third
  end
end
