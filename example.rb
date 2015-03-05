require './Delete'
require './Retrieve'
require './Send'
require './Utilities'



retrieve = Retrieve.new
send = Send.new
delete = Delete.new



email = 'btheer108@gmail.com'
subject = 'hihi'
text = 'hey'
delete.delete_all_emails_in_array(email, ['hihi', ' '])
# send.send_mail(text, subject, email, email)



# retrieve.getEmail('ba')

