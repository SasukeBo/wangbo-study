class CommentsController < ApplicationController
  def create
    @article = Article.find_by(user_id: params[:user_id], id: params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to user_article_path(current_user, @article)
    #@article = Article.find(params[:article_id])
    #@comment = @article.comments.create(comment_params)
    #redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy

    redirect_to user_article_path(current_user, @article)
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
