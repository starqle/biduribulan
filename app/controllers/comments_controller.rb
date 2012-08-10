class CommentsController < ApplicationController
  def create
    @entry = Entry.find(params[:entry_id])
    @comment = @entry.comments.build(params[:comment])
    
    if current_user
      @comment.user = current_user
    end
    
    if @comment.save
      flash[:notice] = 'Comment successfuly created'
    else
      flash[:alert] = 'Failed creating comment'
    end
    redirect_to(@entry.url)
    
  end
 
  def destroy
    @entry = Entry.find(params[:entry_id])
    @comment = @entry.comments.find(params[:id])
    @comment.destroy
    redirect_to(@entry.url)
  end
end
