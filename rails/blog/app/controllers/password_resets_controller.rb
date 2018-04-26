class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "密码不能为空！")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "密码修改成功。"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # 事前过滤器
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 确保用户是有效的
    def valid_user
      unless (@user && @user.activated? &&
          @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # 检查重设令牌是否过期
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "修改密码操作过期。"
        redirect_to new_password_reset_url
      end
    end
end
