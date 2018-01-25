class CommentsController < ApplicationController
  before_action :check_user_is_auth, except: [:ajax_comments]

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to :back
  end

  def ajax_comments
    form_redirect = params[:'form-redirect']
    content = params[:'form-content']
    admin_content = params[:'form-admin-content']
    article_id = params[:'form-article-id']
    site_id = params[:'form-site-id']
    user_id = session['login_user_id']
    #_rucaptcha = params[:'_rucaptcha']

    if !valid_captcha?(params[:captcha])
      render plain: '验证码错误'
    elsif content.nil? || content.to_s.empty?
      render plain: '内容不能为空'
    else
      Comment.create(content:content,
                     admin_comment:admin_content,
                     article_id:article_id,
                     site_id:site_id,
                     user_id:user_id)
      render plain: 'true'
    end
  end

  def create
    form_redirect = params[:'form-redirect']
    content = params[:'form-content']
    admin_content = params[:'form-admin-content']
    article_id = params[:'form-article-id']
    site_id = params[:'form-site-id']
    user_id = session['login_user_id']
    if !verify_rucaptcha?
      form_redirect = form_redirect.gsub('error_msg=','')
      if form_redirect.to_s.include?('?')
        error_redirect = form_redirect+'&error_msg=code'
      else
        error_redirect = form_redirect+'?error_msg=code'
      end
      redirect_to error_redirect
    elsif content.nil? || content.to_s.empty?
      form_redirect = form_redirect.gsub('error_msg=','')
      if form_redirect.to_s.include?('?')
        error_redirect = form_redirect+'&error_msg=empty'
      else
        error_redirect = form_redirect+'?error_msg=empty'
      end
      redirect_to error_redirect
    else
      Comment.create(content:content,
                     admin_comment:admin_content,
                     article_id:article_id,
                     site_id:site_id,
                     user_id:user_id)
      form_redirect = form_redirect.gsub('error_msg=','')
      redirect_to form_redirect
    end
  end

end
