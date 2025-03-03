# name: novalink-feedback-discourse-plugin
# about: Discourse header plugin for Novalink Feedback
# author: Thenurim
# version: 0.1

Rails.application.config.action_dispatch.default_headers.merge!({'X-Frame-Options' => 'ALLOWALL'})
Rails.application.config.action_dispatch.default_headers.merge!({'Access-Control-Allow-Origin' => '*'})
Rails.application.config.action_dispatch.default_headers.merge!({'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS, DELETE'})
Rails.application.config.action_dispatch.default_headers.merge!({'Access-Control-Allow-Headers' => 'Content-Type, Authorization, X-Requested-With'})