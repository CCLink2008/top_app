class AccountActivationsController < ApplicationController
	def edit
		#根据email 查找用户
		user = User.find_by(email:params[:email])
		#用户判断 ， 是否存在用户，用户是否已经激活 ，用户是否合法
		if user && !user.activated? && user.authenticated?(:activation,params[:id])
			#  激活用户
			user.activate
			# 用户登录
			log_in user
			#登录成功提示
			flash[:success] ="Account activated"
			#转到用户信息页面
			redirect_to user 
		else
			#激活失败
			flash[:danger] = "invalid activation link"
			# 转到主页
			redirect_to root_url
	 	end		
	end
end
