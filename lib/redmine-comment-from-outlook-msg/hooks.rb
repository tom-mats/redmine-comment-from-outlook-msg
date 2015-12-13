require 'ruby-msg'

module CommentFromeOutlookMsg
  def self.parse_mail(attachment)
    return nil
  end
  def self.add_message_from_mail(params, key)
    additional_message = []
    if params.key? :attachments
      if params[:attachments].is_a?(Array)
        params[:attachments].each { |attachment|
          additional_message << parse_mail(attachment)
        }
      end
    end
    unless additional_message.empty?
      params[key] = params[key].to_s + "---\n" + additional_message.join("---\n")
    end
  end

  class Hooks < Redmine::Hook::Listener
    def controller_issues_new_before_save(context={})
      add_message_from_mail(params, :description)
    end
    def controller_issues_edit_before_save(context={})
      add_message_from_mail(params, :notes)
    end
  end
end
