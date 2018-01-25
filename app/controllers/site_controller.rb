class SiteController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:ajax_search_articles, :ajax_search_sites]

  def index
    if params[:site_type].nil? || params[:site_type].to_i == 1
      @type=1
      @sites = Site.where(:is_valid => true).order('created_at DESC').page(params[:page])
    else
      @type=params[:site_type].to_i
      @sites = Site.where(:site_type_id => params[:site_type], :is_valid => true).order('created_at DESC').page(params[:page])
    end
  end

  def about
    
  end

  def search_result

  end

  def ajax_search_articles
    if params[:key].nil? || params[:key].to_s.empty?
      result = SearchModel.new(400,'fail','key is null',1,9999,0)
      render plain:result.to_json
    else
      idx = params[:idx]
      lmt = params[:lmt]
      if idx.nil?
        idx=1
      end
      if lmt.nil?
        lmt=5
      end

      articles_tmp = Article.search(params[:key],size:10000).results
      articles = Array.new
      articles_tmp.each do |article|
        if article['_score'] > 0.01
          art = article['_source']
          art['content'] = article['_source']['content'].gsub(/<\/?.*?>/, '')[0,250]
          articles.push article['_source']
        end
      end
      tmp = articles.slice(lmt.to_i*(idx.to_i-1),lmt.to_i)
      result = SearchModel.new(200,'success',tmp,idx.to_i,lmt.to_i,articles.size)
      render plain:result.to_json
    end
  end

  def ajax_search_sites
    if params[:key].nil? || params[:key].to_s.empty?
      result = SearchModel.new(400,'fail','key is null',1,9999,0)
      render plain:result.to_json
    else
      idx = params[:idx]
      lmt = params[:lmt]
      if idx.nil?
        idx=1
      end
      if lmt.nil?
        lmt=5
      end

      sites_tmp = Site.search(params[:key],size:10000).results
      sites = Array.new
      sites_tmp.each do |site|
        if site['_score'] > 0.01
          sites.push site['_source']
        end
      end
      if sites.empty?
        sites_tmp2 = Site.where("url LIKE ? OR reason LIKE ?", "%#{params[:key]}%", "%#{params[:key]}%")
        sites_tmp2.each do |site|
          sites.push site.as_indexed_json
        end
      end
      tmp = sites.slice(lmt.to_i*(idx.to_i-1),lmt.to_i)
      result = SearchModel.new(200,'success',tmp,idx.to_i,lmt.to_i,sites.size)
      render plain:result.to_json
    end
  end

  def sms_send
    phone = params[:'phone']
    func = params[:'func'].to_s
    error='false'
    if /^1[3|4|5|8][0-9]\d{4,8}$/.match(phone)
      if $CACHE_CACHE.exist?(request.ip)
        session[:sms_code] = $CACHE_CACHE.read(request.ip)
        render plain: true
      else
        if phone.nil? && !session['login_user_id'].nil?
          user = User.where(:id => session['login_user_id']).first
          unless user.nil?
            phone = user.phone
          end
        elsif !phone.nil?
          user = User.where(:phone => phone).first
          if user.nil?
            phone='0'
            error = '用户不存在'
          end
        end
        if /^1[3|4|5|8][0-9]\d{4,8}$/.match(phone)
          sms_code = rand(9999).to_s
          if func == 'sign_up'
            send_sms_sign_up(phone,sms_code)
          else
            send_sms_user_auth(phone,sms_code)
          end
          session[:sms_code] = sms_code
          $CACHE_CACHE.write(request.ip,sms_code,:expires_in=>1.minutes)
          render plain: true
        else
          render plain: error
        end
      end
    else
      error = '手机号码格式错误'
      render plain: error
    end
  end

  def sms_send_reg
    phone = params[:'phone']
    func = params[:'func'].to_s
    error='false'
    if /^1[3|4|5|8][0-9]\d{4,8}$/.match(phone)
      if $CACHE_CACHE.exist?(request.ip)
        session[:sms_code] = $CACHE_CACHE.read(request.ip)
        render plain: true
      else
        if phone.nil? && !session['login_user_id'].nil?
          user = User.where(:id => session['login_user_id']).first
          unless user.nil?
            phone = user.phone
          end
        elsif !phone.nil?
          user = User.where(:phone => phone).first
          if !user.nil?
            phone='0'
            error = '用户已存在'
          end
        end
        if /^1[3|4|5|8][0-9]\d{4,8}$/.match(phone)
          sms_code = rand(9999).to_s
          if func == 'sign_up'
            send_sms_sign_up(phone,sms_code)
          else
            send_sms_user_auth(phone,sms_code)
          end
          session[:sms_code] = sms_code
          $CACHE_CACHE.write(request.ip,sms_code,:expires_in=>1.minutes)
          render plain: true
        else
          render plain: error
        end
      end
    else
      error = '手机号码格式错误'
      render plain: error
    end
  end

  def sms_send_admin
    phone = Settings.get('admin','phone')
    if $CACHE_CACHE.exist?(request.ip)
      session[:sms_code] = $CACHE_CACHE.read(request.ip)
      render plain: true
    else
      if /^1[3|4|5|8][0-9]\d{4,8}$/.match(phone)
        sms_code = rand(9999).to_s
        send_sms_user_auth(phone,sms_code)
        session[:sms_code] = sms_code
        $CACHE_CACHE.write(request.ip,sms_code,:expires_in=>1.minutes)
        render plain: true
      else
        render plain: false
      end
    end
  end

  def upload_image
    if session['login_user_id'].nil? || session['login_user_id'].to_s.empty?
      render plain: 'false'
    else
      unless params[:fileup] && (tempfile = params[:fileup].tempfile)
        render plain: 'false'
      else
        begin
          bucket = $OSS_Client.get_bucket('imgrc')
          filename = "attachments/#{SecureRandom.uuid}.jpg"
          bucket.put_object(filename, :file => tempfile)
          render plain: URI.decode(bucket.object_url(filename, false))
        rescue Exception => e
          render plain: 'false'
        end
      end
    end
  end

  def upload_avatar
    if session['login_user_id'].nil? || session['login_user_id'].to_s.empty?
      render plain: 'false'
    else
      unless params[:fileup] && (tempfile = params[:fileup].tempfile)
        render plain: 'false'
      else
        begin
          bucket = $OSS_Client.get_bucket('imgrc')
          filename = "avatars/#{session['login_user_id']}/#{SecureRandom.uuid}.jpg"
          bucket.put_object(filename, :file => tempfile)
          render plain: URI.decode(bucket.object_url(filename, false))
        rescue Exception => e
          render plain: 'false'
        end
      end
    end
  end

end
