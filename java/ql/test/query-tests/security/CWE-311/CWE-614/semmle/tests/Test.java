// Semmle test case for CWE-614: Sensitive Cookie in HTTPS Session Without 'Secure' Attribute
// http://cwe.mitre.org/data/definitions/614.html
package test.cwe614.semmle.tests;




import javax.servlet.http.*;

class Test {
	public static void test(HttpServletRequest request, HttpServletResponse response) {
		{
			Cookie cookie = new Cookie("secret" ,"fakesecret");
			
			// BAD: secure flag not set
			response.addCookie(cookie);
			
		}
		
		{
			Cookie cookie = new Cookie("secret" ,"fakesecret");
			
			// GOOD: set secure flag
			cookie.setSecure(true);
			response.addCookie(cookie);
		}
	}
}
