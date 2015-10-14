class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :no_notes?
  rescue_from CanCan::AccessDenied do |exception|
    render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
  end
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def no_notes?
    current_user.notes.empty?
  end

  def render_404
    render file: "#{Rails.root}/public/404", formats: [:html], status: 404, layout: false
  end
end
