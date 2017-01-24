class Users::Devise::SessionsController < Devise::SessionsController


  respond_to :json

  # layout :blank


  skip_before_filter :verify_authenticity_token


  # GET /resource/sign_in
  def OLD_new

    self.resource = resource_class.new(sign_in_params)

    clean_up_passwords(resource)

    if params[:alert] == 'email_exists'
      @alert = 'Your email is already in our system. Please log in.'
    end

    # binding.pry
    respond_with(resource, serialize_options(resource))

    # render 'users/devise/sessions/new'

  end

  # POST /resource/sign_in
  def old_create

    user = User.find_by_email(params[:email])

    if user.nil?
      return login_problem :address
    end

    unless user.confirmed_at || (user.confirmation_sent_at && user.confirmation_sent_at > Time.now - 2.days)
      return redirect_to '/help/confirm_email?email=' + params[:email]
    end

    if params[:password]
      unless user.valid_password?(params[:password])
        user_log(action: :login_failed, description: 'incorrect password', user_id: user.id)
        return login_problem :password
      end
    end

    if params[:auth_token]
      unless params[:auth_token] == user.auth_token
        user_log(action: :login_failed, description: 'incorrect auth token', user_id: user.id)
        return login_problem :password
      end
    end

    sign_in(:user, user)

    session[:mobile_app] = true if params[:mobile_app].present?
    session[:timezone]   = $geoip.region(request.remote_ip).timezone

    login_type = mobile_app? ? 'login with app' : 'login'

    user_log(action: login_type, description: "log in from #{request.remote_ip}", data: { user_agent: request.user_agent })

    user.generate_auth_token

    if session[:user_return_to]
      return respond_with user, location: session[:user_return_to]
    else
      return respond_with user, location: '/me/dashboard'
    end

  end

  def login_problem(reason)

    if request_format == :json
      return render json: { status: :failed, reason: reason }, status: 403
    end

    @login_problem = reason

    render action: 'new', locals: { resource: User.new, login_problem: reason }

  end

  # DELETE /resource/sign_out
  def destroy

    user_log(action: :logout) unless switched_user?

    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield if block_given?
    respond_to_on_destroy
  end


end
