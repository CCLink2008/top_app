class User < ActiveRecord::Base
    #属性访问
	attr_accessor :remember_token,:activation_token,:reset_token
    #保存之前，把email格式化为小写字母
    before_save :downcase_email
    before_create :create_activation_digest
    #User 有很多微博，如何用户被删除，相关的微博也会删除
	has_many :microposts,dependent: :destroy
    # 主动关系 模型名为Relationship  外键 follower_id 该用户关注了哪些用户
    has_many :active_relationships, class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy
    #被动关系 模型名为Relationship 外键 followed_id 该用户被哪些用户关注
    has_many :passive_relationships , class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy
    has_many :following , through: :active_relationships,source: :followed
    has_many :followers , through: :passive_relationships, source: :follower

	# validates :name,:email, presence:true 
	validates :name,presence:true,length:{maximum:50}	
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email,presence:true,length:{maximum:255},
	           format: { with:VALID_EMAIL_REGEX },
	          uniqueness:{case_sensitive: false } 


    has_secure_password
    validates :password,length:{minimum:6},allow_blank:true
    
    # 根据字符串 创建一个密文信息
    def User.digest(string)
    	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)	    	
    end
    # create a random taken 
    # 创建一个随机的令牌
    def User.new_token
    	SecureRandom.urlsafe_base64    	
    end
    #记住用户， 
    def remember
        # 用new_token 创建一个记住用户的令牌
    	self.remember_token = User.new_token
        # 根据令牌密文设置和用户相关的数据库字段记录信息，
    	update_attribute(:remember_digest,User.digest(remember_token))
    end
    #忘记用户，即用户退出 
    def forget
        #将记住用户字段信息 置为 nil
    	update_attribute(:remember_digest,nil)
    end
    #return true if the given token matches the digest
    #返回 true 如果给定的hash码与摘要（digest）匹配
    def authenticated?(attribtue,token)
        digest = send("#{attribtue}_digest")
    	return false if digest.nil?
    	BCrypt::Password.new(digest).is_password?(token)    	
    end
    #激活用户
    def activate
        update_attribute(:activated, true)
        update_attribute(:activated_at,Time.zone.now)        
    end
    #发送激活邮件 
    def send_activation_email
        UserMailer.account_activation(self).deliver
    end
    # 创建密码重置摘要
    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest,User.digest(reset_token))
        update_attribute(:reset_sent_at,Time.zone.now)
    end
    #发送密码重置邮件 
    def send_password_reset_email
        UserMailer.password_reset(self).deliver
    end
    # 密码重置url是否过期？ 过期时间为2小时 
    def password_reset_expired?
        reset_sent_at <2.hours.ago 
    end
    def feed
        following_ids = "select followed_id from relationships 
                            where follower_id = :user_id "

       Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id",user_id: id)
    end 
    #follows a user  关注一个用户
    def follow(other_user)
      active_relationships.create(followed_id:other_user.id)       
    end  
    #unfollows a user  取消关注一个用户
    def unfollow(other_user)
       active_relationships.find_by(followed_id:other_user.id).destroy      
    end 
    #return true if the current user is following the other user  判断当前用户和其他用户的关系
    def following?(other_user)
        following.include?(other_user)
    end 
    private
        # 将邮件格式转换为小写
        def downcase_email
            self.email = email.downcase
        end
        #创建用户激活摘要信息
        def create_activation_digest
            self.activation_token = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
end



