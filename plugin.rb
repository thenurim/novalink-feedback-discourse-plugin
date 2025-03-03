# name: novalink-feedback-discourse-plugin
# about: Discourse header plugin for Novalink Feedback
# author: Thenurim
# version: 0.1

after_initialize do

  # secure_headers 설정을 수정하여 X-Frame-Options 및 CSP의 frame-ancestors 지시어를 변경합니다.
  
  # SecureHeaders::Configuration.default.tap do |config|
  #   # X-Frame-Options 헤더를 수정 (주의: ALLOW-FROM은 일부 브라우저에서 지원하지 않습니다)
  #   #config.x_frame_options = "ALLOW-FROM http://localhost"
  #   config.x_frame_options = "ALLOW-FROM http://localhost:5173"

  #   # CSP 설정에서 frame-ancestors 지시어를 사용하여 iframe 포함을 허용할 도메인을 명시합니다.
  #   # 권장: ALLOW-FROM 대신 frame-ancestors를 활용하는 방법
  #   config.csp[:frame_ancestors] = ["'self'", "http://localhost:5173"]

  #   # 필요한 경우 다른 CSP directive도 수정할 수 있습니다.
  #   # 예: config.csp[:default_src] = ["'self'", "https://your-allowed-domain.com"]
  #   config.csp[:default_src] = ["'self'", "http://localhost:5173"]
  # end

  # Rails.application.config.session_store :cookie_store,
  #   key: '_discourse_session',
  #   same_site: :none,
  #   secure: true

# CSP middleware to add our security headers
  class NovalinkFeedbackSecurityHeadersMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)
      
      # Set X-Frame-Options (note: modern browsers prefer CSP frame-ancestors)
      # X-Frame-Options doesn't support multiple origins, using ALLOW-FROM with first URL
      headers['X-Frame-Options'] = 'ALLOW-FROM http://localhost'

      # Get existing CSP header or create a new one
      csp = headers['Content-Security-Policy'] || ''
      
      # Add frame-ancestors directive to allow localhost and localhost:5173
      unless csp.include?('frame-ancestors')
        csp += " frame-ancestors 'self' http://localhost http://localhost:5173;"
      end
      
      # Add default-src directive 
      unless csp.include?('default-src')
        csp += " default-src 'self' http://localhost http://localhost:5173;"
      end
      
      # Update the header
      headers['Content-Security-Policy'] = csp.strip
      
      [status, headers, response]
    end
  end

  # Insert the middleware
  Rails.application.middleware.insert_before ActionDispatch::Static, NovalinkFeedbackSecurityHeadersMiddleware

  # Optional: Log that the plugin has been initialized
  Rails.logger.info "Novalink Feedback plugin initialized with hardcoded values for localhost"
end

# Controller to test the headers (optional, using correct controller inheritance)
module ::NovalinkFeedback
  class SecHeadersController < ::ApplicationController
    requires_plugin 'novalink-feedback-discourse-plugin'
    skip_before_action :check_xhr, :redirect_to_login_if_required

    def index
      render plain: "Novalink Feedback security headers test page - Headers are set to allow http://localhost and http://localhost:5173"
    end
  end
end

# Only add the routes if the plugin is enabled
if defined?(NovalinkFeedback)
  Discourse::Application.routes.append do
    get '/novalink_feedback_test' => 'novalink_feedback/sec_headers#index'
  end
end