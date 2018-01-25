class UsersController < ApplicationController
  before_action :check_user_is_auth, except: [:login, :register, :postlogin, :postregister, :logout, :ajax_register, :ajax_login, :changepassword_out, :ajax_update_password_out]

  def usercenter
    @user = User.find(session['login_user_id'])
  end

  def userinfo
    @user = User.find(session['login_user_id'])
  end

  def comments
    @comments = Comment.where(:user_id => session['login_user_id']).order('created_at DESC').page(params[:page])
  end

  def messages
    @messages = Message.where(:user_id => [session['login_user_id'], '0']).order('created_at DESC').page(params[:page])
  end

  def changepassword

  end

  def changepassword_out
    @is_show_login_assets = true
  end

  def changephone

  end

  def ajax_update
    user_id = session['login_user_id']
    avatar = params[:'form-avatar']
    nickname = params[:'form-nickname']
    email = params[:'form-email']
    description = params[:'form-description']
    sex = params[:'form-sex']
    user = User.find(user_id)
    if user.nil?
      render plain: 'false'
    else
      if nickname.nil? || nickname.to_s.empty?
        nickname = user.username
      end
      user.nickname=nickname
      user.avatar=avatar
      user.email=email
      user.sex=sex
      user.description=description
      if user.save!
        render plain: 'true'
      else
        render plain: 'false'
      end
    end
  end

  def ajax_update_password_out
    phone = params['form-phone']
    password = params[:'form-password']
    repassword = params[:'form-repassword']
    smscode = params[:'form-smscode']

    user = User.where(:phone => phone).first
    if user.nil?
      render plain: '该用户不存在'
    elsif password.to_s != repassword.to_s
      render plain: '请输入两次相同密码'
    elsif smscode.to_s != session[:sms_code].to_s
      render plain: '短信验证码错误'
    elsif password.to_s.length < 6
      render plain: '密码至少6位'
    else
      user.password_digest = Digest::MD5.hexdigest(password);
      unless user.save!
        render plain: '密码修改失败'
      else
        if user.permission_id==99
          Settings.set('admin','password',password,true)
        end
        render plain: 'true'
      end
    end
  end

  def ajax_update_password
    user_id = session['login_user_id']
    password = params[:'form-password']
    repassword = params[:'form-repassword']
    smscode = params[:'form-sms']
    if password.to_s != repassword.to_s
      render plain: '请输入两次相同密码'
    elsif smscode.to_s != session[:sms_code].to_s
      render plain: '短信验证码错误'
    elsif password.to_s.length < 6
      render plain: '密码至少6位'
    else
      user = User.find(user_id)
      if user.nil?
        render plain: '用户信息有误'
      else
        user.password_digest = Digest::MD5.hexdigest(password);
        unless user.save!
          render plain: '更新失败'
        else
          if user.permission_id==99
            Settings.set('admin','password',password,true)
          end
          render plain: 'true'
        end
      end
    end
  end

  def login
    @error_name = ''
    @error_class = 'hidden'
    @is_show_login_assets = true
    if $CACHE_CACHE.read('captcha'+request.ip)=='-'
      @is_show_captcha = true
    end
  end

  def register
    @error_class = 'hidden'
    @is_show_login_assets = true
  end

  def logout
    cookies.delete(:user_id)
    cookies.delete(:user_token)
    session.delete('login_user_id')
    session.delete('login_user_nickname')
    session.delete('login_user_permission_id')
    unless request.referer.nil?
      redirect_to request.referer
    else
      redirect_to '/'
    end
  end

  def ajax_login
    form_redirect = params[:'form-redirect']
    username = params[:'form-username']
    password = params[:'form-password']
    is_remember = params[:'form-remember']
    if username.nil? || username.to_s.empty?
      render plain: '用户名不能为空'
    elsif password.nil? || password.to_s.empty?
      render plain: '密码不能为空'
    elsif !valid_captcha?(params[:captcha]) && $CACHE_CACHE.read('captcha'+request.ip)=='-'
      render plain: '图形验证码错误'
    else
      user = User.where(:username => username, :password_digest => Digest::MD5.hexdigest(password)).first
      unless user.nil?
        if user.permission_id==99
          $CACHE_CACHE.write('captcha'+request.ip,'-',:expires_in=>10.minutes)
          render plain: '你没有权限'
        else
          session['login_user_id'] = user.id
          session['login_user_nickname'] = user.nickname
          session['login_user_permission_id'] = user.permission_id
          if !is_remember.nil? && is_remember=='Remember Me'
            cookies[:user_id] = { :value => user.id.to_s , :expires => 1.month.from_now }
            cookies[:user_token] = {
                :value => Digest::MD5.hexdigest(user.username + user.password_digest) ,
                :expires => 1.month.from_now }
          end
          render plain: 'true'
        end
      else
        $CACHE_CACHE.write('captcha'+request.ip,'-',:expires_in=>10.minutes)
        render plain: '用户名或密码错误'
      end
    end
  end

  def postlogin
    form_redirect = params[:'form-redirect']
    username = params[:'form-username']
    password = params[:'form-password']
    is_remember = params[:'form-remember']
    user = User.where(:username => username, :password_digest => Digest::MD5.hexdigest(password)).first
    unless user.nil?
      if user.permission_id==99
        redirect_to '/admin/index.html'
      else
        session['login_user_id'] = user.id
        session['login_user_nickname'] = user.nickname
        session['login_user_permission_id'] = user.permission_id
        if !is_remember.nil? && is_remember=='Remember Me'
          cookies[:user_id] = { :value => user.id.to_s , :expires => 1.month.from_now }
          cookies[:user_token] = {
              :value => Digest::MD5.hexdigest(user.username + user.password_digest) ,
              :expires => 1.month.from_now }
        end
        unless form_redirect.nil? || form_redirect.to_s=='' || form_redirect.to_s.include?('login') || form_redirect.to_s.include?('register')
          redirect_to form_redirect
        else
          redirect_to '/'
        end
      end
    else
      @error_class = ''
      @error_msg = '用户名或密码错误'
      @error_name = username
      @is_show_login_assets = true
      @is_special_page = true
      render 'login'
    end
  end


  def ajax_register
    username = params[:'form-username']
    password = params[:'form-password']
    repassword = params[:'form-repassword']
    phone = params[:'form-phone']
    smscode = params[:'form-sms']
    if username.nil? || username.to_s.empty?
      render plain: '用户名不能为空'
    elsif !/^[0-9a-zA-Z]*$/.match(username)
      render plain: '用户名只能是字母和数字的组合'
    elsif password.nil? || password.to_s.empty?
      render plain: '密码不能为空'
    elsif password.to_s != repassword.to_s
      render plain: '密码不一致'
    elsif phone.nil? || phone.to_s.empty?
      render plain: '手机号不能为空'
    elsif !/^1[3|4|5|8][0-9]\d{4,8}$/.match(phone)
      render plain: '手机号码有误'
    elsif smscode.nil? || smscode.to_s.empty?
      render plain: '短信验证码不能为空'
    elsif smscode.to_s != session[:sms_code].to_s
      render plain: '短信验证码错误'
    elsif !valid_captcha?(params[:captcha])
      render plain: '图形验证码错误'
    elsif !User.where(:username => username).take.nil?
      render plain: '用户已存在'
    elsif password.to_s.length < 6
      render plain: '密码至少6位'
    else
      user = User.create(username: username,
                         nickname: username,
                         password_digest: Digest::MD5.hexdigest(password),
                         phone: phone,
                         avatar: '/img/default-avatar.jpg',
                         permission_id:1)
      session['login_user_id'] = user.id
      session['login_user_nickname'] = user.nickname
      session['login_user_permission_id'] = user.permission_id
      cookies[:user_id] = { :value => user.id.to_s , :expires => 1.month.from_now }
      cookies[:user_token] = {
          :value => Digest::MD5.hexdigest(user.username + user.password_digest) ,
          :expires => 1.month.from_now }
      render plain: 'true'
    end
  end

  def postregister
    username = params[:'form-username']
    password = params[:'form-password']
    repassword = params[:'form-repassword']
    phone = params[:'form-phone']
    smscode = params[:'form-sms']
    tmp = User.where(:username => username).take
    if !tmp.nil?
      set_reg_error '用户已存在'
      render 'register'
    elsif !verify_rucaptcha?
      set_reg_error '图形验证码错误'
      render 'register'
    elsif !/^[0-9a-zA-Z]*$/.match(username)
      set_reg_error '用户名只能是字母和数字的组合'
      render 'register'
    elsif password.to_s != repassword.to_s
      set_reg_error '密码不一致'
      render 'register'
    elsif password.to_s.length < 6
      set_reg_error '密码至少6位'
      render 'register'
    elsif !/^1[3|4|5|8][0-9]\d{4,8}$/.match(phone)
      set_reg_error '手机号码有误'
      render 'register'
    elsif smscode.to_s != '1234' #session[:sms_code].to_s
      set_reg_error '短信验证码错误'
      render smscode.to_s
    else
      user = User.create(username: username,
                         nickname: username,
                         password_digest: Digest::MD5.hexdigest(password),
                         phone: phone,
                         avatar: '/img/default-avatar.jpg',
                         permission_id:1)
      session['login_user_id'] = user.id
      session['login_user_nickname'] = user.nickname
      session['login_user_permission_id'] = user.permission_id
      cookies[:user_id] = { :value => user.id.to_s , :expires => 1.month.from_now }
      cookies[:user_token] = {
          :value => Digest::MD5.hexdigest(user.username + user.password_digest) ,
          :expires => 1.month.from_now }
      redirect_to '/'
    end
  end

  def set_reg_error msg
    @error_class = ''
    @error_msg = msg
    @is_show_login_assets = true
    @is_special_page = true
  end

end
