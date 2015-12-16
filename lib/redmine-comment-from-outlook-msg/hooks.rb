require 'mapi/msg'

module CommentFromOutlookMsg
  MAX_MIME_LINE = 72
  HEADER_CONTENTS = {
    "From" => /<([A-Za-z0-9.]+@[A-Za-z0-9.]+)>/,
    "To" => /<([A-Za-z0-9.]+@[A-Za-z0-9.]+)>/,
    "Cc" => /<([A-Za-z0-9.]+@[A-Za-z0-9.]+)>/,
    "Subject" => /(.+)/,
    "Date" => /(.+)/
  }
  def self.logger(log_message)
    log = Rails.logger
    log.info(log_message) if log
  end
  def self.parse_mail(attachment)
    mail_message = []
    if attachment.is_a?(Hash)
      hash_data = attachment
      a = Attachment.find_by_token(hash_data[:token]) if hash_data.has_key? :token
      if a && a.diskfile && File.exist?(a.diskfile)
        if File.extname(a.diskfile) == ".msg"
          msg = Mapi::Msg.open(a.diskfile)
          mime = msg.to_mime
          HEADER_CONTENTS.each do |key, regexp|
            message = []
            if mime.headers.has_key?(key)
              message << key + " : "
              mime.headers[key].each do |header|
                if header =~ regexp
                  message << $1
                end
              end
            end
            mail_message << message.join(",")
          end
          actual_line = ""
          msg.properties.body.split("\n").each do |line|
            break if line =~ /^>+(-|\s|_)+$/
            actual_line += line.chomp
            next if line.length > MAX_MIME_LINE
            mail_message << actual_line
            actual_line = ""
          end
          msg.close
        end
      end
    end
    if mail_message.present?
      mail_message.join("\n")
    else
      nil
    end
  end
  def self.add_message_from_mail(params)
    additional_message = []
    if params.key? :attachments
      if params[:attachments].is_a?(Hash)
        params[:attachments].each do |key, attachment|
          additional_message << parse_mail(attachment)
        end
      end
    end
    additional_message.compact!
    if additional_message.present?
      "\n\n---\n\n" + additional_message.join("\n\n---\n\n")
    else
      ""
    end
  end

  class Hooks < Redmine::Hook::Listener
    def controller_issues_new_before_save(context={})
      context[:issue].description << CommentFromOutlookMsg::add_message_from_mail(context[:params])
    end
    def controller_issues_edit_before_save(context={})
      context[:issue].notes << CommentFromOutlookMsg::add_message_from_mail(context[:params])
    end
  end
end
