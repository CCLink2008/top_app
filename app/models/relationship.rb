class Relationship < ActiveRecord::Base
	#属于很多 follower  
	belongs_to :follower, class_name: "User"
	#属于很多 followed 
	belongs_to :followed, class_name: "User"
	validates :follower_id, presence: true
	validates :followed_id, presence: true
end
