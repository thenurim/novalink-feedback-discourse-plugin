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

  Rails.logger.info "Initializing Novalink Feedback plugin to modify security headers..."

  # Monkey patch ApplicationController to add our headers
  ::ApplicationController.class_eval do
    # Store the original method reference
    alias_method :orig_append_content_security_policy_header, :append_content_security_policy_header

    # Override the method to add our custom policies
    def append_content_security_policy_header
      # Call original method first
      orig_append_content_security_policy_header

      # Add our custom frame-ancestors and default-src directives
      response.headers["Content-Security-Policy"] = response.headers["Content-Security-Policy"].to_s.gsub(
        /frame-ancestors[^;]*;/,
        "frame-ancestors 'self' http://localhost http://localhost:5173;"
      )

      if !response.headers["Content-Security-Policy"].to_s.include?("frame-ancestors")
        response.headers["Content-Security-Policy"] = "#{response.headers["Content-Security-Policy"]} frame-ancestors 'self' http://localhost http://localhost:5173;"
      end

      # Set X-Frame-Options
      response.headers["X-Frame-Options"] = "ALLOW-FROM http://localhost"

      Rails.logger.debug "Modified security headers: #{response.headers["Content-Security-Policy"]}"
    end
  end

  Rails.logger.info "Novalink Feedback plugin initialized successfully"
end