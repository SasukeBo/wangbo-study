class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user # 加入友好转向
      else
        message = "账号未激活，"
        message += "请查看您的邮箱，激活账号！"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = '错误的Username或password!'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    # 在执行log_out之前先要判断用户首否已登录
    # 因为当某个用户在多个页面执行退出操作时，会报错。
    redirect_to root_path
  end
end
