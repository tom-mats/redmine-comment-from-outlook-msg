from lib/plugins/acts_as_attachable/lib/acts_as_attachable.rb

```ruby
def save_attachments(attachments, author=User.current)
  if attachments.is_a?(Hash)
    attachments = attachments.stringify_keys
    attachments = attachments.to_a.sort {|a, b|
      if a.first.to_i > 0 && b.first.to_i > 0
        a.first.to_i <=> b.first.to_i
      elsif a.first.to_i > 0
        1
      elsif b.first.to_i > 0
        -1
      else
        a.first <=> b.first
      end
    }
    attachments = attachments.map(&:last)
  end
  if attachments.is_a?(Array)
    attachments.each do |attachment|
      next unless attachment.is_a?(Hash)
      a = nil
      if file = attachment['file']
        next unless file.size > 0
        a = Attachment.create(:file => file, :author => author)
      elsif token = attachment['token']
        a = Attachment.find_by_token(token)
        next unless a
        a.filename = attachment['filename'] unless attachment['filename'].blank?
        a.content_type = attachment['content_type'] unless attachment['content_type'].blank?
      end
      next unless a
      a.description = attachment['description'].to_s.strip
      if a.new_record?
        unsaved_attachments << a
      else
        saved_attachments << a
      end
    end
  end
  {:files => saved_attachments, :unsaved => unsaved_attachments}
end
```
