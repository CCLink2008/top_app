class RelationshipsController < ApplicationController
	# 验证是否登录用户
	before_action :logged_in_user
    #关注 
	def create
		@user = User.find(params[:followed_id])
		current_user.follow(@user)
		respond_to do |format|
			format.html { redirect_to @user }
			format.js # 使用ajax 
		end
	end
	#取消关注
	def  destroy 
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow(@user)
		respond_to do |format|
		  format.html { redirect_to @user }
		  format.js #使用ajax
		end		
	end
end