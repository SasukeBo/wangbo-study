class WelcomeController < ApplicationController

  def home
    @micropost = current_user.microposts.build if logged_in?
  end

  def index
  end
  def show

  end
end
