class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user # 加入友好转向
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
