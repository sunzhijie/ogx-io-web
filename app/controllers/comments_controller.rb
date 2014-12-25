class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_commentable, only: [:index, :create]

  layout false

  def index
    @comments = @commentable.comments
    respond_with(@comments)
  end

  def show
    respond_with(@comment)
  end

  def edit
  end

  def new
    @comment = Comment.new
    @comment.commentable_type = params[:commentable_type]
    @comment.commentable_id = params[:commentable_id]
    @comment.parent_id = params[:parent_id]
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.commentable_id = @comment.commentable_id.to_i
    @comment.user = current_user
    @comment.save

    respond_to do |format|
      format.html { redirent_to @comment }
      format.js
    end
  end

  def update
    @comment.update(comment_params)
    respond_with(@comment)
  end

  def destroy
    @comment.destroy
    respond_with(@comment)
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params[:comment].permit(:body, :parent_id, :commentable_type, :commentable_id)
  end

  def set_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable = $1.classify.constantize.find(value)
      end
    end
  end

end
