require 'net/smtp'
require 'mail'
require 'base64'
require_relative 'Utilities.rb'

include Utilities

class Send

  def initialize
    server = 'smtp.gmail.com'
    mail_from_domain = 'gmail.com'
    port = 587      # or 25 - double check with your provider
    username =  'btheer108@gmail.com'
    password = 'bobtheer108'
    @smtp = Net::SMTP.new(server, port)

    @smtp.enable_starttls_auto
    @smtp.start(server,username,password, :plain)

  end

  def send_mail(text, subject, sender, rcpt)
    email = 'btheer108@gmail.com'
    message = <<END_OF_EMAIL
From: Your Name <#{sender}>
To: Other Email <#{rcpt}>
Subject: #{subject}

#{text}
END_OF_EMAIL

    @smtp.send_message(message, sender, rcpt)
  end

end

