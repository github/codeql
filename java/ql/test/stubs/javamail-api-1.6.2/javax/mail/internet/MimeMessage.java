package javax.mail.internet;

import javax.mail.Address;
import javax.mail.Session;
import javax.mail.Multipart;
import javax.mail.Message;

public class MimeMessage extends Message {

    public MimeMessage(Session session) { }

    public void setSubject(String subject) { }

    public void setFrom(Address address) { }

    public void setContent(Multipart mp) { }

    public Address[] getAllRecipients() {
        return null;
    }
}