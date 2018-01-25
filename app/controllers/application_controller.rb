class ApplicationController < ActionController::Base
  # reset captcha code after each request for security
  after_filter :reset_last_captcha_code!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_auto_login

  def send_sms_sign_up num,code
    Alidayu::Sms.send_code_for_sign_up(num, {code: code}, '')
  end

  def send_sms_user_auth num,code
    Alidayu::Sms.send_code_for_user_auth(num, {code: code}, '')
  end

  def check_auto_login
    if session['login_user_id'].nil? && !cookies[:user_id].nil?
      user = User.where(:id => cookies[:user_id]).first
      if !user.nil? && Digest::MD5.hexdigest(user.username + user.password_digest)==cookies[:user_token]
        session['login_user_id'] = user.id
        session['login_user_nickname'] = user.nickname
        session['login_user_permission_id'] = user.permission_id
      else
        cookies.delete(:user_id)
      end
    end
  end

  def check_user_is_auth
    if session['login_user_id'].nil?
      redirect_to login_url
    end
  end

  def check_admin_is_auth
    if session['login_user_id'].nil? || session['login_user_permission_id'].to_s.to_i < 80
      redirect_to '/admin/login.html'
    end
  end

  def render_404
    if Rails.env == 'production'
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
        format.xml  { head :not_found }
        format.any  { head :not_found }
      end
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  class SearchModel
    def initialize (code,msg,data,idx,lmt,total)
      @code = code
      @msg = msg
      @data = data
      @idx = idx
      @lmt = lmt
      @total = total
    end

    def to_json
      return Hash[:code => @code, :msg => @msg, :idx => @idx, :lmt => @lmt, :total => @total, :data => @data].to_json
    end

    def code
      @code
    end
    def code(code)
      @code=code
    end

    def msg
      @msg
    end
    def msg(msg)
      @msg=msg
    end

    def data
      @data
    end
    def data(data)
      @data=data
    end

    def idx
      @idx
    end
    def idx=(idx)
      @idx=idx
    end

    def lmt
      @lmt
    end
    def lmt=(lmt)
      @lmt=lmt
    end

    def total
      @total
    end
    def total=(total)
      @total=total
    end
  end

end
