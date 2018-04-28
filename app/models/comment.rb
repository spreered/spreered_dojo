class Comment < ApplicationRecord
  belongs_to :post, counter_cache: :replies_count
  belongs_to :author, class_name: 'User'
end
