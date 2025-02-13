class Api::PostsController < ApplicationController
    before_action :set_post, only: [:show, :update, :destroy]

    # fetch all posts
    def index
        # get all post from our model
        @posts = Post.all
        # then serilized into json
        render json: @posts, include: [:tags, :comments, user:{only: [:name]}], status: :ok
    end
    
    # get post by id
    def show
        render json: @post, include: [:tags, :comments ], status: :ok
    end

    # create post
    def create
        # check current user is post owner
        @post = current_user.posts.build(post_params)
        
        # check
        if @post.save
            # get tag & id
            render json: @post.as_json(include: { tags: { only: [:id, :name] } }), status: :created
        else
            render json: { errors: 'someting went wrong' }, status: :unprocessable_entity
        end
    end

    # update post
    def update
        if @post.user == current_user && @post.update(post_params)
            render json: @post.as_json(include: { tags: { only: [:id, :name] } }), status: :ok
        else
            render json: { error: "not authorized or invalid data" }, status: :unauthorized
        end
    end

    # post delete
    def destroy
        if @post.user == current_user
        render json: @post.destroy
            head :no_content
        else
            render json: { error: "not authorized" }, status: :unauthorized
        end
    end
    
    private

    def set_post
        @post = Post.find_by(id: params[:id])
        unless @post
            render json: { error: 'post not found' }, status: :not_found
        end
    end

    def post_params
        params.require(:post).permit(:title, :body, tag_names: [])
    end
end
