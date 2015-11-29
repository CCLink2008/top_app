class User < ActiveRecord::Base
	attr_accessor :remember_token
	has_many :microposts
	 # before_save {self.email = email.downcase!}
	before_save { self.email = email.downcase }
	# validates :name,:email, presence:true 
	validates :name,presence:true,length:{maximum:50}	
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email,presence:true,length:{maximum:255},
	           format: { with:VALID_EMAIL_REGEX },
	          uniqueness:{case_sensitive: false } 


    has_secure_password
    validates :password,length:{minimum:6}
    
    def User.digest(string)
    	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)	    	
    end
    #create a random taken 
    def User.new_taken
    	SecureRandom.urlsafe_base64
    	
    end
    def remember
    	self.remember_token = User.new_taken
    	update_attribute(:remember_digest,Usre.digest(remember_token))
    end
    def forget
    	update_attribute(:remember_digest,nil)
    end
    #return true if the given token matches the digest
    def authenticated?(remember_token)
    	BCrypt::Password.new(remember_digest).is_password?(remember_token)    	
    end
end



