module Cyptoify
  class Notify
    require 'mail'
    class << self
      def send_notification(message)
        Mail.deliver do
            from     ENV['DEFAULT_MAIL_FROM']
            to       ENV['DEFAULT_MAIL_TO']
            subject  "#{message}-EOM"
        end
      end
    end
  end
end
