class Survey < ApplicationRecord
  has_one :category
  has_many :questions, class_name:Question, dependent: :destroy
  belongs_to :administrator, class_name: Administrator, foreign_key: :id
end
