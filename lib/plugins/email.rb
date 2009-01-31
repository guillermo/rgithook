require 'tmail'
require 'socket'

class Email < RGitHook::Plugin

   option :destination, "Destination of email functions", %x(who am i), [String]

   module RunnerMethods
      include TMail


      # Send a multipart html email, converting html to text for plain_text emails
      # In Uses Tmail
      #
      #   mail('test resutls', '<html><body>Good results!</body></html>')
      def email(subject,body,to=nil)
         part = Mail.new
         part.set_content_type "text", "html"
         part.body = body.to_html
         mail         = Mail.new
         mail.to      = to
         mail.from    = "rgithook@#{Socket.gethostname}"
         mail.subject = subject
         mail.body    = body.gsub('</p>',"\n").gsub('</br>',"\n").gsub(/<\/?[^>]*>/, "")
         mail.parts << part
         mail
         sendmail(mail)
         mail
      end

      private
      def sendmail(mail)
         sendmail = IO.popen("/usr/sbin/sendmail #{mail.to}", "w")
         sendmail.write mail.to_s
         sendmail.close
      end
   end
end

