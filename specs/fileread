```ruby
     if params[:attachments]
        params[:attachments].each do |attachment|
          a = Attachment.find_by_token(attachment[1][:token])
          logger.info("TEST type " + a.diskfile )
          File.open(a.diskfile) {|io|
            while line = io.gets
              logger.info(line)
            end
          }
        end
      end
```
