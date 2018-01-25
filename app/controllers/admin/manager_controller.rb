class Admin::ManagerController < ApplicationController
  before_action :check_admin_is_auth

  def member
    unless params[:s].nil? || params[:s]==''
      users_tmp = User.search(params[:s],size:10000).results
      tmp = Array.new
      users_tmp.each do |user|
        if user['_score'] > 0.01
          tmp.push User.find(user['_source'].id)
        end
      end
      @users = tmp
    else
      @users = User.all.page(params[:page])
    end
  end

  def member_edit
    @user = User.find(params[:id])
  end

  def member_edit_post
    user = User.find(params[:form_id])
    if params[:form_sex]=='男'
      user.sex=1
    elsif params[:form_sex]=='女'
      user.sex=2
    else
      user.sex=0
    end
    user.nickname = params[:form_nickname]
    unless params[:form_password].nil? || params[:form_password]==''
      user.password_digest = Digest::MD5.hexdigest(params[:form_password])
    end
    user.email = params[:form_email]
    user.description = params[:form_description]
    user.avatar = params[:form_avatar]
    if params[:form_permission]=='管理员'
      user.permission_id=89
    elsif params[:form_permission]=='用户'
      user.permission_id=1
    end
    user.save
    unless params[:form_referer].nil?
      redirect_to params[:form_referer]
    else
      redirect_to '/admin/member.html'
    end
  end

  def send_message
    @to_uid = params[:to_uid]
  end

  def send_message_post
    content = params[:form_edit]
    type = params[:form_type]
    if type=='全体会员'
      users = User.where(:permission_id => 1)
      users.each do |user|
        Message.create(content:content,
                       sender:session['login_user_id'],
                       user_id:user.id)
      end
    elsif type=='指定用户id'
      user_id= params[:form_flag]
      Message.create(content:content,
                     sender:session['login_user_id'],
                     user_id:user_id)
    elsif type=='指定电话号码'
      user_id= User.where(:phone => params[:form_flag]).first.id
      Message.create(content:content,
                     sender:session['login_user_id'],
                     user_id:user_id)
    end
    redirect_to :back
  end

  def site_list
    unless params[:s].nil? || params[:s]==''
      sites_tmp = Site.search(params[:s],size:10000).results
      tmp = Array.new
      sites_tmp.each do |site|
        if site['_score'] > 0.01
          tmp.push Site.find(site['_source'].id)
        end
      end
      if tmp.empty?
        sites_tmp2 = Site.where("url LIKE ? OR reason LIKE ?", "%#{params[:key]}%", "%#{params[:key]}%")
        sites_tmp2.each do |site|
          tmp.push site
        end
      end
      @sites = tmp
    else
      @sites = Site.all.order('is_valid').order('id desc').page(params[:page])
    end
  end

  def site_new
    @site_types = SiteType.all
  end

  def site_new_post
    site = Site.new
    site.url = params[:form_url]
    site.alias_url = Time.now.to_i
    site.title = params[:form_title]
    site.images = params[:form_images]
    site.site_type_id = SiteType.where(:title => params[:form_type]).first.id
    site.short_reason = params[:form_short_reason]
    site.reason = params[:form_reason]
    site.note = params[:form_note]
    site.count = params[:form_count]
    site.is_valid = true
    site.save
    site.alias_url = site.id.to_s + Digest::MD5.hexdigest(Time.now.to_s)[0,6].to_s
    site.save
    redirect_to '/admin/site-list.html'
  end

  def site_edit
    @site = Site.find(params[:id])
    @site_types = SiteType.all
  end

  def site_edit_post
    site = Site.find(params[:form_id])
    if site.alias_url.nil? || site.alias_url==''
      site.alias_url = site.id.to_s + Digest::MD5.hexdigest(Time.now.to_s)[0,6].to_s
    end
    site.url = params[:form_url]
    site.title = params[:form_title]
    site.images = params[:form_images]
    site.site_type_id = SiteType.where(:title => params[:form_type]).first.id
    site.short_reason = params[:form_short_reason]
    site.reason = params[:form_reason]
    site.note = params[:form_note]
    site.count = params[:form_count]
    site.save
    unless params[:form_referer].nil?
      redirect_to params[:form_referer]
    else
      redirect_to '/admin/site-list.html'
    end
  end

  def site_pass
    site = Site.find(params[:id])
    site.is_valid = true
    site.save
    count = Settings.get('site','site_count').to_s.to_i+1
    Settings.set('site','site_count',count.to_s)
    # redirect_to :back
    redirect_to '/admin/site-list.html'
  end

  def site_delete
    site = Site.find(params[:id])
    site.destroy
    redirect_to :back
  end

  def article_edit
    @article = Article.find(params[:id])
    @article_types = ArticleType.all
  end

  def article_edit_post
    article = Article.find(params[:form_id])
    unless article.nil?
      article.title = params[:form_title]
      article.alias_url = article.id.to_s + '-' + Pinyin.translate(params[:form_title], splitter: '')
      article.content = params[:form_content]
      article.article_type_id = ArticleType.where(:title => params[:form_type]).first.id
      if article.user_id.nil? || article.user_id==''
        article.user_id = session['login_user_id']
      end
      article.save
    end
    redirect_to '/admin/article-list.html'
  end

  def article_new
    @article_types = ArticleType.all
  end

  def article_new_post
    article = Article.new
    article.title = params[:form_title]
    article.content = params[:form_content]
    article.article_type_id = ArticleType.where(:title => params[:form_type]).first.id
    article.user_id = session['login_user_id']
    article.save
    article.alias_url = article.id.to_s + '-' + Pinyin.translate(params[:form_title], splitter: '')
    article.save
    redirect_to '/admin/article-list.html'
  end

  def article_delete
    article = Article.find(params[:id])
    article.destroy
    redirect_to '/admin/article-list.html'
  end

  def article_list
    unless params[:s].nil? || params[:s]==''
      articles_tmp = Article.search(params[:s],size:10000).results
      tmp = Array.new
      articles_tmp.each do |article|
        if article['_score'] > 0.01
          tmp.push Article.find(article['_source'].id)
        end
      end
      @articles = tmp
    else
      @articles = Article.all.order('created_at DESC').page(params[:page])
    end
  end

  def article_colum_manage
    @article_types = ArticleType.all
  end

  def article_colum_add
    title = params[:form_title]
    alias_url = params[:form_alias]
    unless title.nil? || title==''
      ArticleType.create(title:title, alias_url:alias_url)
    end
    redirect_to '/admin/article-colum-manage.html'
  end

  def article_colum_edit
    @type = ArticleType.find(params[:id])
  end

  def article_colum_edit_post
    type = ArticleType.find(params[:form_id])
    unless type.nil?
      type.title = params[:form_title]
      type.alias_url = params[:form_alias]
      type.save
    end
    redirect_to '/admin/article-colum-manage.html'
  end

  def article_colum_delete
    type = ArticleType.find(params[:id])
    type.destroy
    redirect_to '/admin/article-colum-manage.html'
  end

  def commet_list
    @comments = Comment.all.page(params[:page])
  end

  def commet_delete
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to :back
  end

  def site_setting

  end

  def site_setting_post
    Settings.set('site','title',params[:form_site_title],false)
    Settings.set('site','copyright',params[:form_site_copyright],false)
    Settings.set('site','top_notice',params[:form_site_top_notice],false)
    Settings.set('site','top_notice_link',params[:form_site_top_notice_link],false)
    Settings.set('site','name',params[:form_site_name],false)
    Settings.set('site','s_name',params[:form_site_s_name],false)
    Settings.set('site','site_count',params[:form_site_site_count],false)
    Settings.set('site','weibo',params[:form_site_weibo],false)
    Settings.set('site','weixin',params[:form_site_weixin],false)
    Settings.set('site','qq',params[:form_site_qq],false)
    Settings.set('site','email',params[:form_site_email],false)
    Settings.set('site','bottom_left',params[:form_site_bottom_left],false)
    Settings.set('site','bottom_center',params[:form_site_bottom_center],false)
    Settings.set('site','bottom_right',params[:form_site_bottom_right],false)
    Settings.save_config
    redirect_to :back
  end

  def menu_edit
    @menus = Link.all
    @pages = Page.all
    @article_types = ArticleType.all
  end

  def menu_edit_post
    unless params[:form_title].nil? || params[:form_title]==''
      if params[:form_type]=='站内页面'
        url = '/page/' + Page.where(:title => params[:form_in_type]).first.alias_url.to_s + '.html'
      elsif params[:form_type]=='文章分类'
        url = '/category/' + ArticleType.where(:title => params[:form_article_type]).first.alias_url.to_s + '.html'
      else
        url = params[:form_url]
      end
      Link.create(url:url,
                  title:params[:form_title],
                  sort:params[:form_sort])
    end
    redirect_to :back
  end

  def menu_item_edit
    @link = Link.find(params[:id])
    @pages = Page.all
    @article_types = ArticleType.all
  end

  def menu_item_edit_post
    link = Link.find(params[:form_id])
    unless params[:form_title].nil? || params[:form_title]==''
      link.title = params[:form_title]
      link.sort = params[:form_sort]
      if params[:form_type]=='站内页面'
        link.url = '/page/' + Page.where(:title => params[:form_in_type]).first.alias_url.to_s + '.html'
      elsif params[:form_type]=='文章分类'
        link.url = '/category/' + ArticleType.where(:title => params[:form_article_type]).first.alias_url.to_s + '.html'
      else
        link.url = params[:form_url]
      end
      link.save
    end
    redirect_to '/admin/menu-edit.html'
  end

  def menu_item_delete
    link = Link.find(params[:id])
    link.destroy
    redirect_to '/admin/menu-edit.html'
  end

  def page_new

  end

  def page_delete
    page = Page.find(params[:id])
    page.destroy
    redirect_to '/admin/page-list.html'
  end

  def page_edit
    @page = Page.find(params[:id])
  end

  def page_new_post
    title = params[:form_title]
    alias_url = params[:form_alias]
    content = params[:form_content]
    if alias_url.nil? || alias_url.to_s==''
      alias_url= Pinyin.translate(params[:form_title], splitter: '')
    end
    Page.create(title:title,
                alias_url:alias_url,
                content:content)
    redirect_to '/admin/page-list.html'
  end

  def page_edit_post
    id = params[:form_id]
    title = params[:form_title]
    alias_url = params[:form_alias]
    content = params[:form_content]
    if alias_url.nil? || alias_url.to_s==''
      alias_url= Pinyin.translate(params[:form_title], splitter: '')
    end
    page = Page.find(id)
    unless page.nil?
      page.title = title
      page.alias_url=alias_url
      page.content = content
      page.save
    end
    redirect_to '/admin/page-list.html'
  end

  def page_list
    @pages = Page.all
  end

end
