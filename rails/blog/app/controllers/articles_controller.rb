class ArticlesController < ApplicationController
  before_action :current_article, only: [:destroy, :update, :edit]
  def index
    @articles = Article.where(user_id: params[:user_id])
    puts "params[:user_id]的值为：", params[:user_id]

    # @artilces.each do |a|
      #puts "文章：", a
    #end
  end

  def show
    # @article = Article.find(params[:id])
    puts "params[:user_id] 的值是", params[:user_id]
    puts "params[:id] 的值是", params[:id]
    @article = Article.find_by(user_id: params[:user_id], id: params[:id])
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    # render plain: params[:article].inspect
    @article = Article.new(article_params)
    @article.user_id = params[:user_id]
    if @article.save
      redirect_to user_articles_path
    else
      render 'new'
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to user_articles_path
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to user_articles_path
  end

  private

    def article_params
      params.require(:article).permit(:title, :text, :user_id)
    end

    def current_article
      unless Article.find_by(id: params[:id])
        flash[:danger] = "文章不存在，可能已被删除"
        redirect_to user_articles_path
      end
    end
end
