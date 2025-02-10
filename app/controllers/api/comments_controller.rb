class Api::CommentsController < ApplicationController
    before_action :set_post
    before_action :set_comment, only: [:update, :destroy]

    # add comment
    def create
        @comment = @post.comments.build(comment_params)
        @comment.user = current_user

        if @comment.save
            render json: @comment, status: :created
        else
            render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
        end
    end

    #update comment
    def update
        #check if comment owner who the updater
        if @comment.user == current_user && @comment.update(comment_params)
            render json: @comment, status: :ok
        else
            render json: { error: "Not authorized or invalid data" }, status: :unauthorized
        end
    end

    #delete comment
    def destroy
        if @comment.user == current_user
            @comment.destroy
            head :no_content
        else
            render json: { error: "Not authorized" }, status: :unauthorized
        end
    end

    private
    #get the post
    def set_post
        @post = Post.find(params[:post_id])
    end

    #get comment of post
    def set_comment
        @comment = @post.comments.find(params[:id])
    end

    def comment_params
        params.require(:comment).permit(:body)
    end
end