# name: novalink-feedback-discourse-plugin
# about: Discourse header plugin for Novalink Feedback
# author: Thenurim
# version: 0.1

Rails.application.config.action_dispatch.default_headers.merge!({'X-Frame-Options' => 'ALLOWALL'})
Rails.application.config.action_dispatch.default_headers.merge!({'Access-Control-Allow-Origin' => '*'})
Rails.application.config.action_dispatch.default_headers.merge!({'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS, DELETE'})
Rails.application.config.action_dispatch.default_headers.merge!({'Access-Control-Allow-Headers' => 'Content-Type, Authorization, X-Requested-With'})
Rails.application.config.action_dispatch.default_headers.merge!({'Content-Security-Policy' => "default-src 'self' http://localhost http://localhost:5173; frame-ancestors 'self' http://localhost http://localhost:5173;"})


# # Content-Security-Policy 헤더를 위한 이벤트 설정
# on(:before_send_headers) do |controller|
#   # CSP 헤더 설정 (기존 헤더를 덮어씀)
#   controller.response.headers["Content-Security-Policy"] = "default-src 'self' http://localhost http://localhost:5173; frame-ancestors 'self' http://localhost http://localhost:5173;"
  
#   # # 로그에 헤더 설정 기록
#   # Rails.logger.warn "NOVALINK FEEDBACK PLUGIN: Security headers have been configured for cross-origin requests"
#   # Rails.logger.debug "X-Frame-Options: #{controller.response.headers['X-Frame-Options']}"
#   # Rails.logger.debug "CSP: #{controller.response.headers['Content-Security-Policy']}"
#   # Rails.logger.debug "CORS: #{controller.response.headers['Access-Control-Allow-Origin']}"
# end