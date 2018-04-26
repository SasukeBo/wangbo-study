class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    puts '#'*100
    puts params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # user.update_attribute(:activated,    true)
      # user.update_attribute(:activated_at, Time.zone.now)
      # 将用户激活内置到user model
      user.activate
      log_in user
      flash[:success] = "账号激活成功!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
