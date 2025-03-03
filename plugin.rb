# name: novalink-feedback-discourse-plugin
# about: Discourse header plugin for Novalink Feedback
# author: Thenurim
# version: 0.1

after_initialize do
  module NovalinkFeedbackDiscourse
    # PLUGIN_NAME ||= "novalink-feedback-discourse".freeze
    PLUGIN_NAME = "novalink-feedback-discourse-plugin"
  
  #   class Engine < ::Rails::Engine
  #     engine_name NovalinkFeedbackDiscourse::PLUGIN_NAME
  #     isolate_namespace NovalinkFeedbackDiscourse
  #   end
  #     secure_headers 설정을 수정하여 X-Frame-Options 및 CSP의 frame-ancestors 지시어를 변경합니다.
  
    SecureHeaders::Configuration.default.tap do |config|
      # X-Frame-Options 헤더를 수정 (주의: ALLOW-FROM은 일부 브라우저에서 지원하지 않습니다)
      #config.x_frame_options = "ALLOW-FROM http://localhost"
      config.x_frame_options = "ALLOW-FROM http://localhost:5173"

      # CSP 설정에서 frame-ancestors 지시어를 사용하여 iframe 포함을 허용할 도메인을 명시합니다.
      # 권장: ALLOW-FROM 대신 frame-ancestors를 활용하는 방법
      config.csp[:frame_ancestors] = ["'self'", "http://localhost:5173"]

      # 필요한 경우 다른 CSP directive도 수정할 수 있습니다.
      # 예: config.csp[:default_src] = ["'self'", "https://your-allowed-domain.com"]
      config.csp[:default_src] = ["'self'", "http://localhost:5173"]
    end

    Rails.application.config.session_store :cookie_store,
    key: '_discourse_session',
    same_site: :none,
    secure: true
  end
  

end