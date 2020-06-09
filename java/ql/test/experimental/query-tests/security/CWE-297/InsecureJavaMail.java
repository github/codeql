import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;

import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.Email;
import org.apache.commons.mail.SimpleEmail;

import java.util.Properties;

class InsecureJavaMail {
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
			// properties.put("mail.smtp.ssl.checkserveridentity", "true");
		}
		final Session session = Session.getInstance(properties, authenticator);
	}

	public void testSimpleMail() {
		Email email = new SimpleEmail();
		email.setHostName("config.hostName");
		email.setSmtpPort(25);
		email.setAuthenticator(new DefaultAuthenticator("config.username", "config.password"));
		email.setSSLOnConnect(true);
		// email.setSSLCheckServerIdentity(true);
		email.setFrom("fromAddress");
		email.setSubject("subject");
		email.setMsg("body");
		email.addTo("toAddress");
		email.send();
	}
}