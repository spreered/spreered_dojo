class Friendship < ApplicationRecord
  belongs_to :friendships_inviter, class_name:'User', foreign_key:'user_id'
  belongs_to :friendships_invitee, class_name:'User', foreign_key:'friend_id'
end
