require 'net/imap'
require 'net/ssh'
require 'uri'
require 'optparse'
require 'cgi'
require 'mail'
require 'time'
require_relative 'Utilities.rb'
include Utilities


class Retrieve
  include Utilities

  def get_all_email_for_all_rcpts
    rcpts = @@options.rcpts
    rcpts.each do |rcpt|
      getEmail(rcpt)
    end
  end

  def get_email_for_all_rcpts(subjects)
    rcpts = @@options.rcpts
    rcpts.each do |rcpt|
      get_emails_with_subject(rcpt, subjects)
    end
  end

  def get_emails_with_subject(rcpt, subjects_to_search_for)
    num_message_count = 0
    loop_retry_count = 0
    imap = getImap(rcpt)
    temp = subjects_to_search_for
    puts "temp: #{temp}" if @@options.debug
    while loop_retry_count < 10 && !temp.empty? do
      mailIds = imap.search(['ALL'])
      mailIds.each do |id|
        begin
          msg = imap.fetch(id, 'RFC822')[0].attr['RFC822']
          mail = Mail.read_from_string(msg)
          if temp.include?(mail.subject)
            next if mail.html_part.nil? || mail.text_part.nil?
            do_parsing(mail)
            temp.delete(mail.subject)
            puts "temp: #{temp}" if @@options.debug
            num_message_count += 1
            imap.store(id, "+FLAGS", [:Seen])
          end
        rescue => e
          puts "Failed in fetching message"
          puts e
        end
      end
      loop_retry_count += 1
    end
    puts "Got #{num_message_count} messages for #{rcpt}"
    imap.logout()
    imap.disconnect()
  end

  def getEmail(rcpt)
    count = 0
    imap = getImap(rcpt)
    mailIds = imap.search(['ALL'])
    mailIds.each do |id|
      count += 1
      begin
        msg = imap.fetch(id, 'RFC822')[0].attr['RFC822']
        mail = Mail.read_from_string(msg)
        next if mail.html_part.nil? || mail.text_part.nil?
        imap.store(id, "+FLAGS", [:Seen])
      rescue => e
        puts "Failed in fetching message"
        puts e
      end
    end
    puts "Got #{count} messages for #{rcpt}"
    imap.logout()
    imap.disconnect()
  end

end
