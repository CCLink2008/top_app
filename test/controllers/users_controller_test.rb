require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup 
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should redirect index when not logged in" do 
   get :index
   assert_redirected_to login_url
  end

   # test "should get index" do
   #   get :index
   #   assert_response :success
   #   assert_not_nil assigns(:users)
   # end

  test "should get new" do
    get :new
    assert_response :success
  end

  # test "should create user" do
    # assert_difference('User.count') do
      # post :create, user: { email: @user.email, name: @user.name,password_digest:@user.password_digest}
  # end

    # assert_redirected_to user_path(assigns(:user))
  # end

  

  # test "should update user" do
    # patch :update, id: @user, user: { email: @user.email, name: @user.name,password_digest:@user.password_digest }
    # assert_redirected_to user_path(assigns(:user))
    # assert_redirected_to user_path
  # end

  test "should redirect edit when not logged in" do 
     get :edit ,id:@user
     assert_not flash.empty?
     assert_redirected_to login_url
  end 
  test "should redirect update when not logged in" do 
    patch :update ,id: @user , user:{name:@user.name,email:@user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end 
  #  test "should redirect edit when logged in as wrong user" do 
  #    # log_in_as(@other_user)
  #    get :edit ,id: @user 
  #    assert flash.empty?
  #    assert_redirected_to root_url
  # end 
  # test "should redirect update when logged in as wrong user" do 
  #    # log_in_as(@other_user)
  #    patch :update,id: @user ,user:{name:@user.name,email:@user.email}
  #    assert flash.empty?
  #    assert_redirected_to root_url
  # end


  # test "should destroy user" do
  #   assert_difference('User.count', -1) do
  #     delete :destroy, id: @user
  #   end
  #   assert_redirected_to users_path
  # end
  
  test "should redirect destroy when not logged in" do
      assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect following when not logged in  " do 
     get :following , id: @user
     assert_redirected_to login_url
  end 
  test "should redirect followers when not logged in" do 
    get :followers ,id: @user
    assert_redirected_to login_url 
  end 
end