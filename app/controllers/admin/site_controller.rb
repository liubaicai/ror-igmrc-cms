class Admin::SiteController < ApplicationController
  before_action :check_admin_is_auth, except: [:login, :login_post]

  def index
  end

  def dashboard
  end

  def login
    @error_name = ''
    @error_class = 'hidden'
  end

  def login_post
    username = params[:'form-username']
    password = params[:'form-password']
    smscode = params[:'form-sms']
    is_remember = params[:'form-remember']
    if smscode.to_s != session[:sms_code].to_s
         @error_class = ''
         @error_msg = '短信验证码错误'
         @error_name = username
         render 'login'
    else
      if username == Settings.get('admin','name') && password == Settings.get('admin','password')
        user = User.where(:username => username , :permission_id => 99).first
        if user.nil?
          user = User.new
          user.username=username
          user.nickname='管理员'
          user.avatar='/img/default-avatar.jpg'
          user.password_digest=Digest::MD5.hexdigest(password)
          user.phone=Settings.get('admin','phone')
          user.permission_id=99
          user.save
        else
          user.username=username
          user.password_digest=Digest::MD5.hexdigest(password)
          user.phone=Settings.get('admin','phone')
          user.save
        end
        session['login_user_id'] = user.id
        session['login_user_nickname'] = user.nickname
        session['login_user_permission_id'] = user.permission_id
        if !is_remember.nil? && is_remember=='Remember Me'
          cookies[:user_id] = { :value => user.id.to_s , :expires => 1.month.from_now }
          cookies[:user_token] = {
              :value => Digest::MD5.hexdigest(user.username + user.password_digest) ,
              :expires => 1.month.from_now }
        end
        redirect_to '/admin/index.html'
      else
        @error_class = ''
        @error_msg = '用户名或密码错误'
        @error_name = username
        render 'login'
      end
    end
  end
end
