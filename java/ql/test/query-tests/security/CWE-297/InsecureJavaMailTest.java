import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;

class InsecureJavaMailTest {
	public void testJavaMail() {
		final Properties properties = new Properties();
		properties.put("mail.transport.protocol", "protocol");
		properties.put("mail.smtp.host", "hostname");
		properties.put("mail.smtp.socketFactory.class", "classname");

		final javax.mail.Authenticator authenticator = new javax.mail.Authenticator() {
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

		final javax.mail.Authenticator authenticator = new javax.mail.Authenticator() {
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
