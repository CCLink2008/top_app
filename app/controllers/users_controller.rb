class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user , only:[:index,:edit,:update,:destroy,:following,:followers]
  before_action :correct_user , only:[:edit,:update]
  before_action :admin_user , only: :destroy   


  # GET /users
  # GET /users.json
  def index
     @users = User.paginate(page:params[:page],:per_page => 10)
  end
  def home
    if logged_in?
        @micropost =current_user.microposts.build 
        @feed_items = current_user.feed.paginate(page:params[:page])
    end
  end
  # GET /users/1
  # GET /users/1.json
  def show   
      @microposts = @user.microposts.paginate(page: params[:page])    
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        @user.send_activation_email
        flash[:info] ="Please check your email to activate your account."
        format.html { redirect_to root_url}
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] ="Profile updated!"
        format.html { redirect_to @user}
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end   
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find(params[:id]).destroy    
    respond_to do |format|
      flash[:success] = "User deleted"
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  def following 
    @title = "Foolwing"
    @user = User.find(params[:id])
    @users =  @user.following.paginate(page:params[:page])
    render "show_follow"
  end
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page:params[:page])
    render "show_follow"

  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])     
      # @user = User.find_by_id(params[:id])     
      
      rescue ActiveRecord::RecordNotFound
         redirect_to root_url 
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email,:password,:password_confirmation)
    end
    #验证当前登录用户是否与current uer一致 。
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) 
    end
    #是否是管理员
    def admin_user
      redirect_to(root_url) unless current_user.admin?   
    end
end
