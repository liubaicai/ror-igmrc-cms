module ApplicationHelper

  def time_tostring time
    dayOfWeek = [ '星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六' ]
    #2015年8月24日星期一凌晨2点54分
    time.strftime('%Y年%m月%d日') << dayOfWeek[time.strftime('%w').to_i] << time.strftime('%H时%M分')
  end


  def time_tostring2 time
    dayOfWeek = [ '星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六' ]
    #2016年12月24日 14:23
    time.strftime('%Y年%m月%d日 ') << time.strftime('%H:%M')
  end


  def time_tostring3 time
    #2016-12-24 14:23
    time.strftime('%Y-%m-%d ') << time.strftime('%H:%M')
  end

  def get_new_sites
    cache = $CACHE_CACHE.read('sites_new_5')
    if cache.nil?
      sites = Site.where(:is_valid => true).limit(10).order('created_at DESC')
      $CACHE_CACHE.write('sites_new_5',sites,:expires_in=>1.hours)
      sites
    else
      cache
    end
  end

  def get_current_url
    URI.decode request.url
  end

  def get_current_referer
    unless request.referer.nil?
      URI.decode request.referer
    else
      URI.decode request.url
    end
  end

  def get_sites_count
    cache = $CACHE_CACHE.read('sites_count')
    if cache.nil?
      count = Site.count
      $CACHE_CACHE.write('sites_count',count,:expires_in=>1.hours)
      count
    else
      cache
    end
  end

  def get_site_config key
    Settings.get('site',key)
  end

  def check_user_auth
    if session['login_user_id'].nil?
      return false
    else
      return true
    end
  end

  def check_admin_auth
    if !session['login_user_id'].nil? && session['login_user_permission_id'].to_i>80
      return true
    else
      return false
    end
  end

  def check_super_admin_auth
    if !session['login_user_id'].nil? && session['login_user_permission_id'].to_i>90
      return true
    else
      return false
    end
  end

  def get_all_links
    return Link.order('sort')
  end

  def get_today_comments_count
    Comment.where(:created_at => (Time.now.beginning_of_day..Time.now.end_of_day)).count
  end

  def get_today_articles_count
    Article.where(:created_at => (Time.now.beginning_of_day..Time.now.end_of_day)).count
  end

  def get_today_users_count
    User.where(:created_at => (Time.now.beginning_of_day..Time.now.end_of_day)).count
  end

  def get_today_sites_count
    Site.where(:created_at => (Time.now.beginning_of_day..Time.now.end_of_day)).count
  end
end
