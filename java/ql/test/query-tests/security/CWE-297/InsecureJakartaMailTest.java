import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;

class InsecureJakartaMailTest {
	public void testJavaMail() {
		final Properties properties = new Properties();
		properties.put("mail.transport.protocol", "protocol");
		properties.put("mail.smtp.host", "hostname");
		properties.put("mail.smtp.socketFactory.class", "classname");

		final jakarta.mail.Authenticator authenticator = new jakarta.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication("username", "password");
			}
		};
		if (null != authenticator) {
			properties.put("mail.smtp.auth", "true");
		}
		final Session session = Session.getInstance(properties, authenticator); // $hasInsecureJavaMail
	}

	public void testSecureJavaMail() {
		final Properties properties = new Properties();
		properties.put("mail.transport.protocol", "protocol");
		properties.put("mail.smtp.host", "hostname");
		properties.put("mail.smtp.socketFactory.class", "classname");

		final jakarta.mail.Authenticator authenticator = new jakarta.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication("username", "password");
			}
		};
		if (null != authenticator) {
			properties.put("mail.smtp.auth", "true");
			properties.put("mail.smtp.ssl.checkserveridentity", "true");
		}
		final Session session = Session.getInstance(properties, authenticator); // Safe
	}
}
