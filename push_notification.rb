require 'houston'

# Environment variables are automatically read, or can be overridden by any specified options. You can also
# conveniently use `Houston::Client.development` or `Houston::Client.production`.
APN = Houston::Client.development
APN.certificate = File.read('./development_com.smarttips.Tips.pem')

# An example of the token sent back when a device registers for notifications
token = '46faf038299747ba1212f19391a5ebf63a3a8253e0982ff48ecaf7313c6ad694'

# Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
notification = Houston::Notification.new(device: token)
notification.alert =  { title: 'Dan tipped you 200 rub 💸', body: 'Thank you for an excellent seabass 🔥' }

# Notifications can also change the badge count, have a custom sound, have a category identifier, indicate available Newsstand content, or pass along arbitrary data.
notification.badge = 1
notification.sound = 'sosumi.aiff'
notification.category = 'INVITE_CATEGORY'
notification.content_available = true
notification.mutable_content = true

# And... sent! That's all it takes.
APN.push(notification)
