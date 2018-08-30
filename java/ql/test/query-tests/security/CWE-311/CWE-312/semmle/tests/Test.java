// Semmle test case for CWE-312: Cleartext Storage of Sensitive Information
// http://cwe.mitre.org/data/definitions/312.html
package test.cwe0312.semmle.tests;




import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Cookie;
import java.security.MessageDigest;
import java.net.PasswordAuthentication;
import java.util.Properties;
import java.io.Serializable;
import java.io.OutputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectOutputStream;
import javax.xml.bind.annotation.*;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;

class CWE312 {
	public void test(HttpServletRequest request, HttpServletResponse response) {
		try {
			String data;
			PasswordAuthentication credentials = new PasswordAuthentication(
					"user", "BP@ssw0rd".toCharArray());
			
			{
				data = credentials.getUserName() + ":" + credentials.getPassword();
				// BAD: store data directly in a cookie
				response.addCookie(new Cookie("auth", data));
			}

			{
				Properties p = new Properties();
				data = p.getProperty("password");

				// BAD: store data directly in a cookie
				response.addCookie(new Cookie("auth", data));
			}

			{
				Properties p = new Properties();
				data = credentials.getUserName() + ":" + credentials.getPassword();

				// BAD: store data directly in properties
				p.setProperty("unsecured info!", data);
				OutputStream o = new ByteArrayOutputStream();
				p.store(o, "");
			}

			{
				Properties p = new Properties();
				data = credentials.getUserName() + ":" + credentials.getPassword();

				// BAD: store data on properties using method
				putInProperties(p, data);
				OutputStream o = new ByteArrayOutputStream();
				p.store(o, "");
			}

			{
				data = credentials.getUserName() + ":" + credentials.getPassword();

				// BAD: store data in serializable class
				S s = new S();
				s.setData(data);
				ObjectOutputStream o = new ObjectOutputStream(
						new ByteArrayOutputStream());
				o.writeObject(s);
			}

			{
				data = credentials.getUserName() + ":" + credentials.getPassword();

				// BAD: store data in marshalled class
				S t = new S();
				t.setData(data);
				OutputStream o = new ByteArrayOutputStream();
				JAXBContext context = JAXBContext.newInstance(this.getClass());
				Marshaller m = context.createMarshaller();
				m.marshal(t, o);
			}

			{
				String salt = "ThisIsMySalt";
				MessageDigest messageDigest = MessageDigest.getInstance("SHA-512");
				messageDigest.reset();
				String credentialsToHash = credentials.getUserName() + ":" + credentials.getPassword();
				byte[] hashedCredsAsBytes = messageDigest.digest((salt + credentialsToHash).getBytes("UTF-8"));
				data = bytesToString(hashedCredsAsBytes);

				// GOOD: use encrypted data
				response.addCookie(new Cookie("auth", data));
			}
			
			{
				data = isPasswordChecked();
				// FALSE POSITIVE: the query's detection of what counts as sensitive information
				// can be misled
				response.addCookie(new Cookie("auth", data));
			}
			
			{
				data = getCCNumber();
				// FALSE Negative: the query's detection of what counts as sensitive information
				// is unable to tell in general what can be sensitive information
				response.addCookie(new Cookie("auth", data));
			}
		} catch (Exception e) {
			// fail
		}
	}

	public static String bytesToString(byte[] input) {
		// fake
		return null;
	}

	@XmlRootElement
	public static class S implements Serializable {
		@XmlElement(name = "data")
		String data;

		public void setData(String d) {
			this.data = d;
		}
	}

	public static void putInProperties(Properties p, String s) {
		p.setProperty("stuff", s);
	}
	
	public static String isPasswordChecked() {
		return "true";
	}
	
	public static String getCCNumber() {
		return "Your CC number here";
	}
}
