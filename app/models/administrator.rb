class Administrator < ApplicationRecord
	has_many :surveys, class_name:Survey, dependent: :destroy, foreign_key: :id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
