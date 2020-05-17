import java.util.Properties;

import javax.activation.DataSource;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;

import org.apache.logging.log4j.util.PropertiesUtil;

class JavaMail {
    public static void main(String[] args) {
      // BAD: Don't have server certificate check
      {
		final Properties properties = PropertiesUtil.getSystemProperties();
		properties.put("mail.transport.protocol", "protocol");
		properties.put("mail.smtp.host", "hostname");
		properties.put("mail.smtp.socketFactory.class", "classname");

		final Authenticator authenticator = buildAuthenticator("username", "password");
		if (null != authenticator) {
			properties.put("mail.smtp.auth", "true");
		}
		final Session session = Session.getInstance(properties, authenticator);
      }

      // GOOD: Have server certificate check
      {
		final Properties properties = PropertiesUtil.getSystemProperties();
		properties.put("mail.transport.protocol", "protocol");
		properties.put("mail.smtp.host", "hostname");
		properties.put("mail.smtp.socketFactory.class", "classname");

		final Authenticator authenticator = buildAuthenticator("username", "password");
		if (null != authenticator) {
			properties.put("mail.smtp.auth", "true");
			properties.put("mail.smtp.ssl.checkserveridentity", "true");
		}
		final Session session = Session.getInstance(properties, authenticator);
      }
    }
}