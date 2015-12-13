require 'ruby-msg'

module CommentFromeOutlookMsg
  def self.parse_mail(attachment)
    return nil
  end
  class Hooks < Redmine::Hook::Listener
    def controller_issues_new_before_save(context={})
      if params.key? :attachments
        if params[:attachments].is_a?(Array)
          params[:attachments].each_char { |attachment|
            mail_message = parse_mail(attachment)
            if mail_message
              params[:description] += "---\n" + mail_message
            end
          }
        end
      end
    end
    def controller_issues_edit_before_save(context={})
      if params.key? :attachments
        if params[:attachments].is_a?(Array)
          params[:attachments].each_char { |attachment|
            mail_message = parse_mail(attachment)
            if mail_message
              params[:notes] += "---\n" + mail_message
            end
          }
        end
      end
    end
  end
end
