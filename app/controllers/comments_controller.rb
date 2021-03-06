class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy, :delete_all, :resume]

  layout false

  def create
    @comment = Comment.new(comment_params)
    @comment.commentable_id = @comment.commentable_id.to_i

    authorize @comment.commentable, :comment?

    if @comment.commentable_type == "Post"
      @comment.board = @comment.commentable.board
    end

    @comment.user = current_user
    @comment.user_ip = request.remote_ip
    @comment.user_agent = request.user_agent
    @comment.referer = request.referer

    @comment.save

    respond_to do |format|
      format.js
    end
  end

  def resume
    authorize @comment
    @comment.resume_by(current_user)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    authorize @comment
    @comment.delete_by(current_user)
    respond_to do |format|
      format.js do
        if @comment.deleted == 3
          render 'delete_all'
        end
      end
    end
  end

  def delete_all
    authorize @comment
    @comment.delete_all_by(current_user)
    respond_to do |format|
      format.js
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params[:comment].permit(:body, :parent_id, :commentable_type, :commentable_id)
  end

end
