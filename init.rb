require 'redmine'

require 'redmine-comment-from-outlook-msg/hooks'

Redmine::Plugin.register :redmine_commment_from_outlook_msg do
  name 'Import outlook data to description or comment'
  author 'T. Matsushima'
  description 'This plugin imports mail data of outlook(.msg) to redmine ticket comment or description'
  version 'alpha'
  url 'https://github.com/tom-mats/redmine-comment-from-outlook-msg'
end
