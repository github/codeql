import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.Email;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;

class SimpleMail {
    public static void main(String[] args) throws EmailException {
      // BAD: Don't have setSSLCheckServerIdentity set or set as false    
      {
        Email email = new SimpleEmail();
        email.setHostName("hostName");
        email.setSmtpPort(25);
        email.setAuthenticator(new DefaultAuthenticator("username", "password"));
        email.setSSLOnConnect(true);
        
        //email.setSSLCheckServerIdentity(false);
        email.setFrom("fromAddress");
        email.setSubject("subject");
        email.setMsg("body");
        email.addTo("toAddress");
        email.send();
      }

      // GOOD: Have setSSLCheckServerIdentity set to true
      {
        Email email = new SimpleEmail();
        email.setHostName("hostName");
        email.setSmtpPort(25);
        email.setAuthenticator(new DefaultAuthenticator("username", "password"));
        email.setSSLOnConnect(true);

        email.setSSLCheckServerIdentity(true);
        email.setFrom("fromAddress");
        email.setSubject("subject");
        email.setMsg("body");
        email.addTo("toAddress");
        email.send();
      }
    }
}