class Survey < ApplicationRecord
  has_one :category, class_name:Category, foreign_key: :id
  has_many :questions, class_name:Question, dependent: :destroy
  has_many :answers, class_name:Answer, dependent: :destroy, through: :questions
  belongs_to :administrator, class_name: Administrator, foreign_key: :id, optional: true
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :category_id, presence: true
  validates_associated :questions
end
