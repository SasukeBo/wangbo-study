class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :show, :destroy]
  # 事件过滤器通过before_action方法设定，指定在某个动作运行前调用一个方法
  # logged_in_user方法是用来处理在某些动作运行前的操作。
  before_action :correct_user, only: [:edit, :update]
  # before_action :logged_in_admin, only: [:index]
  before_action :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
=begin
      # 用户信息保存成功后，跳转到登录页面
      log_in @user
      flash[:success] = "欢迎来到Weblog"
      redirect_to @user
=end
      # UserMailer.account_activation(@user).deliver_now
      # 将发送验证邮件功能移到user model中。
      @user.send_activation_email
      flash[:info] = "请在您的邮箱里激活您的Weblog账号。"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "成功删除用户#{params[:username]}"
    redirect_to users_url
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "修改成功"
      redirect_to @user
    else
      render 'edit'
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
        :password_confirmation)
    end

    # 确保当前用户只能编辑自己的个人信息
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 确保是管理员执行删除操作
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
