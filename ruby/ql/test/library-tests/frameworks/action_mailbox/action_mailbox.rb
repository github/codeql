class A < ActionMailbox::Base
  def process
    mail.body
    mail.to
    m = inbound_email
    m.mail.to
  end

  def other_method
    mail.text_part
  end
end

class B < A
    def process
        mail.raw_source
    end
end

class C # not a mailbox class
    def process
        mail.subject
    end
end