require 'net/imap'
require 'uri'
require 'cgi'
require 'time'
require_relative 'Utilities.rb'

include Utilities

class Delete

  def delete_all_emails(rcpt)
    imap = getImap(rcpt)
    mailIds = imap.search(['ALL'])
    mailIds.each do |message_id|
      envelope = imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
      puts "Deleting: #{envelope.subject}" if @@options.debug
      imap.store(message_id, "+FLAGS", [:Deleted]) # must be marked as deleted to be expunged
    end
    imap.expunge
    imap.disconnect()
  end

  def delete_all_emails_in_array(rcpt, to_be_deleted)
    imap = getImap(rcpt)
    mailIds = imap.search(['ALL'])
    mailIds.each do |message_id|
      envelope = imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
      if to_be_deleted.include?(envelope.subject)
        puts "#{envelope.subject} is being deleted and is in array"
        imap.store(message_id, "+FLAGS", [:Deleted]) # must be marked as deleted to be expunged
      else
        puts "#{envelope.subject} is NOT in ARRAY and will NOT be deleted"
      end
    end
    imap.expunge
    imap.disconnect()
  end
end

