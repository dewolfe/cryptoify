module Cyptoify
  class Notify
    require 'mail'
    class << self
      def send_notification(message)
        mail=Mail.new do
            from     ENV['DEFAULT_MAIL_FROM']
            to       ENV['DEFAULT_MAIL_TO']
            subject  "#{message}-EOM"
        end
        mail.delivery_method :sendmail
        mail.deliver
      end
    end
  end
end
