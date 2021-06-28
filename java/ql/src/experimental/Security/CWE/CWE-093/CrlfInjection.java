import java.io.UnsupportedEncodingException;
import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;
import org.apache.commons.mail.DefaultAuthenticator;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class CrlfInjection {

	private static final Logger logger = LoggerFactory.getLogger(CrlfInjection.class);

	@RequestMapping(value = "/crlf1", method = RequestMethod.GET)
	@ResponseBody
	public void bad1(String subject) {
		Properties properties = new Properties();
		properties.setProperty("mail.debug", "false");
		properties.setProperty("mail.smtp.auth", "true");
		properties.setProperty("mail.smtp.host", "smtp.xx.com");
		properties.setProperty("mail.smtp.port", "587");
		properties.setProperty("mail.transport.protocol", "smtp");

		Session session = Session.getInstance(properties, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication("userName", "password");
			}
		});
		MimeMessage msg = new MimeMessage(session);
		try {
			//Bad
			msg.setSubject(subject);
			msg.setFrom(new InternetAddress("\"" + MimeUtility.encodeText("test") + "\"<" + "test@xx.com" + ">"));
			MimeMultipart msgMultipart = new MimeMultipart("mixed");
			msg.setContent(msgMultipart);
			MimeBodyPart htmlPart = new MimeBodyPart();
			msgMultipart.addBodyPart(htmlPart);
			htmlPart.setContent("test", "text/html;charset=utf-8");
			Transport.send(msg, msg.getAllRecipients());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/crlf2", method = RequestMethod.GET)
	@ResponseBody
	public void bad2(String subject) {
		SimpleEmail email = new SimpleEmail();
		email.setSSL(true);
		email.setHostName("smtp.xxx.com");
		email.setSmtpPort(465);
		email.setAuthenticator(new DefaultAuthenticator("userName", "password"));
		try {
			email.setFrom("yyy@xx.com");
			email.addTo("xxx@xx.com");
			//Bad
			email.setSubject(subject);
			email.setMsg("test");
			email.send();
		} catch (EmailException e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/crlf3", method = RequestMethod.GET)
	@ResponseBody
	public void bad3(String subject) {
		logger.info(subject);
	}

	@RequestMapping(value = "/crlf4", method = RequestMethod.GET)
	@ResponseBody
	public void good1(String subject) throws Exception {
		//good
		if (subject.contains("\r\n") || subject.contains("\n")) {
			throw new Exception("error");
		}
		logger.info(subject);
	}
}
