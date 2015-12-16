class MicropostsController < ApplicationController
  # before_action :set_micropost, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user,only:[:create,:destroy]
  before_action :correct_user, only: :destroy
  
  # POST /microposts
  def create
    @micropost = current_user.microposts.build(micropost_params)
    respond_to do |format|
      if @micropost.save
        flash[:success] = "Micropost created"        
        format.html { redirect_to root_url}        
      else
        @feed_items=[]
        format.html { render "users/home" }    
      end
    end
  end

  # DELETE /microposts/1
  def destroy
    @micropost.destroy
    respond_to do |format|
      flash[:success]="Micropost deleted!"
      format.html { redirect_to request.referrer || root_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_micropost
      @micropost = Micropost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def micropost_params
      params.require(:micropost).permit(:content,:picture)
    end
    def correct_user
       @micropost = current_user.microposts.find_by(id:params[:id])
       redirect_to root_url if @micropost.nil?
    end
end
