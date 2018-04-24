module SessionsHelper
  # 登入指定用户
  def log_in(user)
    session[:user_id] = user.id
  end

  # 返回当前登录的用户（如果有的话）
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        lo_in user
        @current_user = user
      end
    end
  end

  # 修改网站布局中的连接时要在ERb中使用if-else语句
  # 用户登录时显示一组链接，未登录时显示另一组链接
  # 为了实现这种功能，我们需要知道用户是否登录，定义logged_in?方法
  def logged_in?
    !current_user.nil?
  end

  # 退出当前用户
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 在持久会话中记住用户
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 忘记持久会话
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
