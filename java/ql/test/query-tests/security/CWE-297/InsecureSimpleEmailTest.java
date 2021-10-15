import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.Email;
import org.apache.commons.mail.SimpleEmail;

public class InsecureSimpleEmailTest {
    public void test() throws Exception {
        // with setSSLOnConnect
        {
            Email email = new SimpleEmail();
            email.setHostName("config.hostName");
            email.setSmtpPort(25);
            email.setAuthenticator(new DefaultAuthenticator("config.username", "config.password"));
            email.setSSLOnConnect(true); // $hasInsecureJavaMail
            email.setFrom("fromAddress");
            email.setSubject("subject");
            email.setMsg("body");
            email.addTo("toAddress");
            email.send();
        }
        // with setStartTLSRequired
        {
            Email email = new SimpleEmail();
            email.setHostName("config.hostName");
            email.setSmtpPort(25);
            email.setAuthenticator(new DefaultAuthenticator("config.username", "config.password"));
            email.setStartTLSRequired(true); // $hasInsecureJavaMail
            email.setFrom("fromAddress");
            email.setSubject("subject");
            email.setMsg("body");
            email.addTo("toAddress");
            email.send();
        }
        // safe with setSSLOnConnect
        {
            Email email = new SimpleEmail();
            email.setHostName("config.hostName");
            email.setSmtpPort(25);
            email.setAuthenticator(new DefaultAuthenticator("config.username", "config.password"));
            email.setSSLOnConnect(true); // Safe
            email.setSSLCheckServerIdentity(true);
            email.setFrom("fromAddress");
            email.setSubject("subject");
            email.setMsg("body");
            email.addTo("toAddress");
            email.send();
        }
        // safe with setStartTLSRequired
        {
            Email email = new SimpleEmail();
            email.setHostName("config.hostName");
            email.setSmtpPort(25);
            email.setAuthenticator(new DefaultAuthenticator("config.username", "config.password"));
            email.setStartTLSRequired(true); // Safe
            email.setSSLCheckServerIdentity(true);
            email.setFrom("fromAddress");
            email.setSubject("subject");
            email.setMsg("body");
            email.addTo("toAddress");
            email.send();
        }
    }
}
