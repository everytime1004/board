class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :tel, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :posts, as: :postable, dependent: :destroy

  before_save :ensure_authentication_token

  has_many :tasks
end
