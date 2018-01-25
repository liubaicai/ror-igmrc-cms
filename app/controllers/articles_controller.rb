class ArticlesController < ApplicationController

  def index
    @title = '安全资讯'
    @articles = Article.where(:s_type => 0).order('created_at DESC').page(params[:page])
  end

  def case
    @articles = Article.where(:s_type => 1).order('created_at DESC').page(params[:page])
  end

  def show
    @article = Article.find(params[:id])
    @comments = Comment.where(:article_id => @article.id).order('created_at DESC').page(params[:page])
    unless params[:error_msg].nil?
      if params[:error_msg].to_s=='code'
        @error_msg = '验证码错误'
      elsif params[:error_msg].to_s=='empty'
        @error_msg = '内容不能为空'
      end
    end
  end

  def type
    @articles = Article.where(:article_type_id => params[:type_id]).order('created_at DESC').page(params[:page])
    @title = ArticleType.where(:id => params[:type_id]).first.title
    render 'index'
  end

  def alias
    @article = Article.where(:alias_url => params[:alias]).first
    if @article.nil?
      render_404
    else
      @comments = Comment.where(:article_id => @article.id).order('created_at DESC').page(params[:page])
      render 'show'
    end
  end

  def type_alias
    type = ArticleType.where(:alias_url => params[:alias]).first
    @title = type.title
    @articles = Article.where(:article_type_id => type.id).order('created_at DESC').page(params[:page])
    render 'index'
  end

end
