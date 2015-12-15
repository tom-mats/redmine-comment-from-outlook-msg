require 'mapi/msg'

module CommentFromeOutlookMsg
  MAX_MIME_LINE = 72
  HEADER_CONTENTS = [
    "To",
    "Cc",
    "Subject",
    "Date"
  ]
  def self.parse_mail(attachment)
    mail_message = []
    if attachment.is_a?(Array) && attachment.size > 1
      hash_data = attachment[1]
      a = Attachment.find_by_token(hash_data[:token]) if hash_data.has_key? :token
      if a && a.diskfile && File.exist?(a.diskfile)
        if File.extname(a.diskfile) == ".msg"
          mime = Mapi.Msg.open(a.diskfile).to_mime
          sender = mine.headers["From"][0].split("<")[0] if mime.headers.has_key? "From"
          mail_message << "From : #{sender}" if sender
          HEADER_CONTENTS.each do |item|
            mail_message << "#{item}: #{mime.headers[item]}" if mime.headers.has_key? item
          end
          actual_line = ""
          msg.properties.body.split("\n").each do |line|
            break if line =~ /^-+$/
            actual_line += line.chomp
            next if line.length > MAX_MIME_LINE
            mail_message << actual_line
            actual_line = ""
          end
        end
      end
    end
    if mail_message.present?
      mail_message.join("\n")
    else
      nil
    end
  end
  def self.add_message_from_mail(params, key)
    additional_message = []
    if params.key? :attachments
      if params[:attachments].is_a?(Array)
        params[:attachments].each do |attachment|
          additional_message << parse_mail(attachment)
        end
      end
    end
    additional_message.compact!
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
