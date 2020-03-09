
import org.apache.commons.mail.*;

public class emailCorrect 
{
    public static void main(String[] args) throws Exception{
        Email email = new SimpleEmail();
        email.setHostName("smtp.googlemail.com");
        email.setSmtpPort(465);
        email.setAuthenticator(new DefaultAuthenticator("username", "password"));
        email.setSSLOnConnect(true);
        email.setFrom("user@gmail.com");
        email.setSubject("TestMail");
        email.setMsg("This is a test mail ... :-)");
        email.addTo("foo@bar.com");
        email.setSSLCheckServerIdentity(true); // This fixes the issue.
        email.send();
    }
}