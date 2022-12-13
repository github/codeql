// Semmle test case for CWE-614: Sensitive Cookie in HTTPS Session Without 'Secure' Attribute
// http://cwe.mitre.org/data/definitions/614.html
package test.cwe614.semmle.tests;




import javax.servlet.http.*;

class Test {

	public static final boolean constTrue = true;

	public static void test(HttpServletRequest request, HttpServletResponse response, boolean alwaysSecure, boolean otherInput) {
		{
			Cookie cookie = new Cookie("secret" ,"fakesecret");

			// BAD: secure flag not set
			response.addCookie(cookie);

		}

		{
			Cookie cookie = new Cookie("secret" ,"fakesecret");

			// BAD: secure flag set to false
			cookie.setSecure(false);
			response.addCookie(cookie);

		}

		{
			Cookie cookie = new Cookie("secret" ,"fakesecret");

			// BAD: secure flag set to something not clearly true or request.isSecure()
			cookie.setSecure(otherInput);
			response.addCookie(cookie);

		}

		{
			Cookie cookie = new Cookie("secret" ,"fakesecret");

			// BAD: secure flag sometimes set to something clearly true or request.isSecure()
			boolean secureVal;
			if(alwaysSecure)
				secureVal = true;
			else
				secureVal = otherInput;
			cookie.setSecure(secureVal);
			response.addCookie(cookie);

		}

		{
			Cookie cookie = new Cookie("secret" ,"fakesecret");

			// GOOD: set secure flag
			cookie.setSecure(true);
			response.addCookie(cookie);
		}

		{
			Cookie cookie = new Cookie("secret" ,"fakesecret");

			// GOOD: set secure flag
			cookie.setSecure(true);
			response.addCookie(cookie);
		}

		{
			Cookie cookie = new Cookie("secret" ,"fakesecret");

			// GOOD: set secure flag
			cookie.setSecure(constTrue);
			response.addCookie(cookie);
		}

		{
			Cookie cookie = new Cookie("secret" ,"fakesecret");

			// GOOD: set secure flag if contacted over HTTPS
			cookie.setSecure(alwaysSecure ? true : request.isSecure());
			response.addCookie(cookie);
		}

		{
			// GOOD: set secure flag in call to `createSecureCookie`
			response.addCookie(createSecureCookie());
		}
	}
	
	private static Cookie createSecureCookie() {
		Cookie cookie = new Cookie("secret", "fakesecret");
		cookie.setSecure(constTrue);
		return cookie;
	}
}
