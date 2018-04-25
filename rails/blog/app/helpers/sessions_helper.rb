module SessionsHelper
  # 登入指定用户
  def log_in(user)
    session[:user_id] = user.id
    # 会在用户的浏览器中创建一个临时的cookie
    # 内容是加密后的用户ID
    # 可以使用session[:user_id]取回这个ID，但是是加密后的ID
  end

  # 返回当前登录的用户（如果有的话）
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
      # 把User.find_by的结果存储在实例变量中，
      # 只在第一次调用current_user时查询数据库。
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
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

  def current_user?(user)
    user == current_user
  end

  # 存储以后需要获取的地址
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
