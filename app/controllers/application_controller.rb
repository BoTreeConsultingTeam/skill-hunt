class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def error_json(message)
    {
      error: message
    }
  end

  def render_forbidden_error_json(message="Forbidden error")
    render(json: error_json(message), status: 403)
  end

  def render_object_not_found_error_json(obj_type, obj_id=nil)
    message = "No #{obj_type.to_s.downcase} found"
    message << " with id #{obj_id}" if obj_id.present?
    render(json: error_json(message), status: 404)
  end

  def model_basic_json(obj, as_json_opts={})
    json = {}
    json[obj.class.name.downcase] = obj.as_json(as_json_opts)
    json
  end

  def model_errors_json(obj)
    json = {}
    json[obj.class.name.downcase] = { errors: obj.errors.to_hash }
    json
  end

  def authenticate_user
    auth_token = params[:authentication_token]
    
    unless auth_token.present?
      render_forbidden_error_json("Authentication Token is required") and return
    end

    if user = User.find_by_authentication_token(auth_token)
      set_session_var(:user_id, user.id)
    else
      render_forbidden_error_json("Invalid user!") and return
    end
  end

  def current_user
    user = User.find_by_id(get_session_var(:user_id))

    unless user
      render_forbidden_error_json("You have not yet authenticated yourself.Please do so to continue..") 
      return
    end

    user    
  end

  def is_current_user_administrator?
    return false unless current_user.present?
    current_user.is_administrator?
  end

  def is_admin_user?
    unless is_current_user_administrator?
      render json: { errors: "Unauthorized action attempted!" }, status: 403
      return
    end
  end

  private 

  def get_session_var(key)
    session[key]
  end

  def set_session_var(key, val)
    session[key] = val
  end

end
