class Category < ApplicationRecord
  validates_presence_of :name
  has_many :post_categories, dependent: :destroy
  has_many :post, through: :post_categories
end
