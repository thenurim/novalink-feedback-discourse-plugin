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

#  # Use Discourse's event system to modify headers after each action
#  on(:before_send_headers) do |controller|
#   if controller.response.headers["Content-Security-Policy"].present?
#     # Modify existing Content-Security-Policy header
#     current_csp = controller.response.headers["Content-Security-Policy"]
    
#     # Replace or add frame-ancestors directive
#     if current_csp.include?("frame-ancestors")
#       current_csp = current_csp.gsub(
#         /frame-ancestors[^;]*;/,
#         "frame-ancestors 'self' http://localhost http://localhost:5173;"
#       )
#     else
#       current_csp += " frame-ancestors 'self' http://localhost http://localhost:5173;"
#     end

#     # Make sure default-src includes our domains
#     if current_csp.include?("default-src")
#       if !current_csp.include?("default-src") || 
#          !(current_csp.include?("http://localhost") && current_csp.include?("http://localhost:5173"))
#         # Add our domains to default-src if they're not already there
#         current_csp = current_csp.gsub(
#           /default-src([^;]*);/,
#           "default-src\\1 http://localhost http://localhost:5173;"
#         )
#       end
#     else
#       current_csp += " default-src 'self' http://localhost http://localhost:5173;"
#     end
    
#     # Update the header
#     controller.response.headers["Content-Security-Policy"] = current_csp
#   else
#     # Set a new Content-Security-Policy header if none exists
#     controller.response.headers["Content-Security-Policy"] = 
#       "frame-ancestors 'self' http://localhost http://localhost:5173; default-src 'self' http://localhost http://localhost:5173;"
#   end

#   # Always set X-Frame-Options
#   controller.response.headers["X-Frame-Options"] = "ALLOW-FROM http://localhost"
  
#   Rails.logger.debug "Modified security headers: #{controller.response.headers["Content-Security-Policy"]}"

  Rails.application.config.action_dispatch.default_headers.merge!({'X-Frame-Options' => 'ALLOWALL'})
  Rails.application.config.action_dispatch.default_headers.merge!({'Access-Control-Allow-Origin' => '*'})
  Rails.application.config.action_dispatch.default_headers.merge!({'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS, DELETE'})
  Rails.application.config.action_dispatch.default_headers.merge!({'Access-Control-Allow-Headers' => 'Content-Type, Authorization, X-Requested-With'})
end

Rails.logger.info "Novalink Feedback plugin initialized successfully"
end