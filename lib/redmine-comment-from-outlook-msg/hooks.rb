require 'ruby-msg'

module CommentFromeOutlookMsg
  class Hooks < Redmine::Hook::Listener
    def controller_issues_new_before_save(context={})
      if params.key? :attachments
        puts params[:attachments].to_h
      end
    end
    def controller_issues_edit_before_save(context={})
      if params.key? :attachments
        puts params[:attachments].to_h
      end
    end
  end
end
