require 'net/ssh'
require 'net/imap'
require 'optparse'
require 'ostruct'

module Utilities

  def getLogonUser (rcpt)
    split_rcpt = rcpt.split
    split_rcpt.length == 2 ? split_rcpt[1] : split_rcpt[0]
  end

  def getEmailAddress (rcpt)
    rcpt.split.first.chomp
  end

  def getImap (rcpt, folder = 'INBOX')
    begin
      # user = getLogonUser(rcpt)
      user = "test@example.com"
      imap = Net::IMAP.new('imap.gmail.com', 993, true)
      imap.login(user.chomp, 'example_pass')
      puts "Logged in as: #{user}"
      imap.select(folder)
      imap
    rescue Exception => e
      puts "Failed in getting Imap server"
      puts e.message
      exit!
    end
  end

end
