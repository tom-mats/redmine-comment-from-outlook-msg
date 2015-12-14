
```ruby
require 'mapi/msg'

msg = Mapi::Msg.open ARGV[0]
mime = msg.to_mime

puts mime.headers["From"][0].split("<")[0]
puts mime.headers["To"]
puts mime.headers["Cc"]
puts mime.headers["Date"]
actual_line = "" 

msg.properties.body.split("\n").each{|line|
  if line.length >= 73 #MIME max line lenght
    actual_line += line.chomp
  else
    actual_line += line
    puts actual_line
    actual_line = "" 
  end
}

puts mime.headers
```
