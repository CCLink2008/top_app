module SessionsHelper
	# 用户登录
	def log_in(user)
		#当前用户ID 写入session中
		session[:user_id] = user.id
		#提示信息 
		flash[:success] = "User log in."
	end
	#记住用户
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id]=user.id 
		cookies.permanent[:remember_token]=user.remember_token
	end
	# 用户退出
	def forget(user)
		#用户退出
		user.forget
		#删除与此用户相关的cookie信息
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end
	#获取当前用户信息
	def current_user
	    #如果session中的user_id 不为空，择根据session中用户id从数据库中查找匹配的用户记录		
	    if (user_id=session[:user_id])
			@current_user||=User.find_by(id:user_id)
		# 如何session中没有用户信息，在从cookie中查找
		elsif (user_id=cookies.signed[:user_id])
			user=User.find_by(id:user_id)
			# 如果用户存在且为合法用户，则登录
			if user && user.authenticated?(:remember,cookies[:remember_token])
				log_in user
				@current_user = user 
			end 
		end		
	end
	# 是否为当前用户
	def current_user?(user)
		current_user == user
	end
	#用户是否登录
	def logged_in?
       !current_user.nil?
    end
    #退出
    def log_out
    	# 忘记用户
    	forget(current_user)
    	#删除session信息
    	session.delete(:user_id)
    	#当前用户置为 nil 
    	@current_user = nil
    end
    #返回上一页 ，后退
    def reditrect_back_or(default)
    	redirect_to(session[:forwarding_url]||default)
    	session.delete(:forwarding_url)
    end
    def store_location
       session[:forwarding_url] = request.url if request.get?
    end
end
