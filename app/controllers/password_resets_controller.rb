class PasswordResetsController < ApplicationController
	before_action :get_user ,   	 only: [:edit,:update]
	before_action :valid_user ,      only: [:edit,:update]
	before_action :check_expiration, only: [:edit,:update]

  def new
  end
  def edit
  end

  def create
    # 根据用户提交的email，查找用户信息
  	@user= User.find_by(email:params[:password_reset][:email].downcase)
    if @user # 如果用户存在
      # 创建密码重置摘要
    	@user.create_reset_digest
      # 发送密码重置邮件 
    	@user.send_password_reset_email
    	flash[:info] = "Email send with passsword reset instructions"
    	redirect_to root_url
    else
    	flash[:danger] = "Email address not found"
    	render "new"
    end
  end
  #密码修改页面
  def update
    # 密码不为空
  	if password_blank?
  		flash.now[:danger] = "Password can't be blank"
  		render "edit"
    #修改用户密码
  	elsif  @user.update_attributes(user_params)
  		log_in @user 
  		flash[:success] = "Password has changed reset"
  		redirect_to @user 
  	else
  		render "edit"
  	end
  end
  private 
      # 设置允许用户提交的参数信息: 密码，密码确认
      def user_params 
      	params.require(:user).permit(:password,:password_confirmation)
      end
      #密码不为空
      def password_blank?
      	params[:user][:password].blank?
      end
      # 根据用户的email 查找用户
  		def get_user
  			@user= User.find_by(email:params[:email])
  		end
      #是否是合法用户，用户不为nil ， 用户已激活，用户已经通过验证
  		def valid_user 
  			unless  (@user&&@user.activated?&&@user.authenticated?(:reset,params[:id]))
  				redirect_to root_url   				
  			end
  		end
  		#判断密码重置url是否过期。有效期为2个小时 
  		def check_expiration
  			if @user.password_reset_expired?
  				flash[:danger] = "Password reset has expired."
				  redirect_to new_password_reset_url
  			end
  		end
end
