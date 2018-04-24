class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  def new
    @user = User.new
  end

  def index

  end

  def create
    @user = User.create(user_params)
    if @user.save
      # redirect_to :sessions_new # 用户信息保存成功后，跳转到登录页面
      redirect_to users_url, alert: "You have successfully registed."
    else
      render new_user_path
    end
  end

  private
  def user_params # 用于过滤传入的参数
    # password_confirmation是用来校对密码是否相同，同时为密码加密
    params.require(:user).permit(
      :nick_name,
      :username,
      :password,
      :email,
      :phone_num,
      :sex,
      :encrypted_password)
  end
end
