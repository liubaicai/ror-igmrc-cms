class SitesController < ApplicationController
  before_action :check_user_is_auth, only: [:new, :create, :ajax_create]

  def new
    @current_user = User.find(session['login_user_id'])
  end

  def show
    key = 'sites_detail_'+params[:id]
    cache = $CACHE_CACHE.read(key)
    if cache.nil?
      @site = Site.find(params[:id])
      $CACHE_CACHE.write(key,@site,:expires_in=>10.minutes)
    else
      @site = cache
    end
    @comments = Comment.where(:site_id => @site.id).order('created_at DESC').page(params[:page])
    unless params[:error_msg].nil?
      if params[:error_msg].to_s=='code'
        @error_msg = '验证码错误'
      elsif params[:error_msg].to_s=='empty'
        @error_msg = '内容不能为空'
      end
    end
  end

  def alias
    @site = Site.where(:alias_url => params[:alias]).first
    if @site.nil?
      render_404
    else
      @comments = Comment.where(:site_id => @site.id).order('created_at DESC').page(params[:page])
      render 'show'
    end
  end

  def ajax_create
    user_id = session['login_user_id']
    if user_id.nil? || user_id.to_s.empty?
      redirect_to :back
    else
      url = params[:'form-url']
      title = params[:'form-title']
      short_reason = params[:'form-short-reason']
      type = params[:'form-type']
      reason = params[:'form-reason']
      images = params[:'form_images']
      email = params[:'form-email']
      phone = params[:'form-phone']
      if url.nil? || url.to_s.empty?
        render plain: '网址不能为空'
      elsif title.nil? || title.to_s.empty?
        render plain: '品牌不能为空'
      elsif short_reason.nil? || short_reason.to_s.empty?
        render plain: '原因不能为空'
      elsif reason.nil? || reason.to_s.empty?
        render plain: '详细原因不能为空'
      elsif email.nil? || email.to_s.empty?
        render plain: '邮箱不能为空'
      else
        site = SitesLog.create(url:url,
                               title:title,
                               reason:reason,
                               short_reason:short_reason,
                               count:1,
                               images:images,
                               is_valid:true,
                               site_type_id:type,
                               email:email,
                               phone:phone,
                               note:params[:'form-note'],
                               user_id:user_id)

        if Site.where(:url => site.url).any?
          t_site = Site.where(:url => site.url).first
          t_site.count = t_site.count + 1
          t_site.save
        else
          r_site = Site.create(url:site.url,
                      alias_url:Time.now.to_i,
                      title:site.title,
                      reason:site.reason,
                      short_reason:site.short_reason,
                      count:1,
                      images:site.images,
                      note:params[:'form-note'],
                      is_valid:false,
                      site_type_id:site.site_type_id)

          r_site.alias_url = r_site.id.to_s + Digest::MD5.hexdigest(Time.now.to_s)[0,6].to_s
          r_site.save
        end
        render plain: 'true'
      end
    end
  end

  def create
    user_id = session['login_user_id']
    if user_id.nil? || user_id.to_s.empty?
      redirect_to :back
    else
      url = params[:'form-url']
      title = params[:'form-title']
      short_reason = params[:'form-short-reason']
      type = params[:'form-type']
      reason = params[:'form-reason']
      images = params[:'form-image']
      email = params[:'form-email']
      phone = params[:'form-phone']
      site = SitesLog.create(url:url,
                             title:title,
                             reason:reason,
                             short_reason:short_reason,
                             count:1,
                             images:images,
                             is_valid:true,
                             site_type_id:type,
                             email:email,
                             phone:phone,
                             note:params[:'form-note'],
                             user_id:user_id)

      if Site.where(:url => site.url).any?
        t_site = Site.where(:url => site.url).first
        t_site.count = t_site.count + 1
        t_site.save
      else
        r_site = Site.create(url:site.url,
                    alias_url:Time.now.to_i,
                    title:site.title,
                    reason:site.reason,
                    short_reason:site.short_reason,
                    count:1,
                    images:site.images,
                    note:params[:'form-note'],
                    is_valid:false,
                    site_type_id:site.site_type_id)

        r_site.alias_url = r_site.id.to_s + Digest::MD5.hexdigest(Time.now.to_s)[0,6].to_s
        r_site.save
      end
      redirect_to index_url
    end
  end

end
