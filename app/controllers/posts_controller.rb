class PostsController < ApplicationController
  def index
    params[:tag] ? @posts = Post.tagged_with(params[:tag]) : @posts = Post.all
  end
  
  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @title_ids = []
    params["ms1"].split(",").each do |data|
      data_name = data.tr('^A-Za-z0-9-/','')
      data = Tag.where(name: data_name).first
      unless data.present?
        data = Tag.create(:name => data_name)
      end
     @title_ids << data.id.to_s
    end
    params[:post][:tag_ids] = @title_ids
    @post = Post.new(post_params)
    if @post.save 
      redirect_to @post 
    else 
      render :new
    end 
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :tag_list, :tag, { tag_ids: [] }, :tag_ids)
  end
end
