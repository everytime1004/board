# encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :tel, :password, :password_confirmation, :remember_me, :phone_first, :phone_second, :phone_third, :phone
  # attr_accessible :title, :body

  validates_numericality_of :phone_second, :only_integer => true
  validates_numericality_of :phone_third, :only_integer => true

  has_many :posts, as: :postable, dependent: :destroy
  has_many :comments, dependent: :destroy

  before_save :ensure_authentication_token, :combine_phone

  has_many :tasks

  def combine_phone
    self.phone = phone_first + phone_second + phone_third
  end
end
