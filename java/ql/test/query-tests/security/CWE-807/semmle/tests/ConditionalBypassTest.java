// Test case for CWE-807 (Reliance on Untrusted Inputs in a Security Decision)
// http://cwe.mitre.org/data/definitions/807.html
package test.cwe807.semmle.tests;

import java.net.InetAddress;
import java.net.Inet4Address;
import java.net.UnknownHostException;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;

class ConditionalBypassTest {
	public static void main(HttpServletRequest request) throws Exception {
		String user = request.getParameter("user");
		String password = request.getParameter("password");

		String isAdmin = request.getParameter("isAdmin");

		// BAD: login is only executed if isAdmin is false, but isAdmin
		// is controlled by the user
		if (isAdmin == "false") // $ hasConditionalBypassTest
			login(user, password);

		Cookie adminCookie = getCookies()[0];
		// BAD: login is only executed if the cookie value is false, but the cookie
		// is controlled by the user
		if (adminCookie.getValue().equals("false")) // $ hasConditionalBypassTest
			login(user, password);

		// GOOD: both methods are conditionally executed, but they probably
		// both perform the security-critical action
		if (adminCookie.getValue() == "false") { // Safe
			login(user, password);
		} else {
			reCheckAuth(user, password);
		}

		// FALSE NEGATIVE: we have no way of telling that the skipped method is sensitive
		if (adminCookie.getValue() == "false") // $ MISSING: hasConditionalBypassTest
			doReallyImportantSecurityWork();

		InetAddress local = InetAddress.getLocalHost();
		// GOOD: reverse DNS on localhost is fine
		if (local.getCanonicalHostName().equals("localhost")) {
			login(user, password);
		}
		if (Inet4Address.getLocalHost().getCanonicalHostName().equals("localhost")) {
			login(user, password);
		}

		InetAddress loopback = InetAddress.getLoopbackAddress();
		// GOOD: reverse DNS on loopback address is fine
		if (loopback.getCanonicalHostName().equals("localhost")) {
			login(user, password);
		}
		if (Inet4Address.getLoopbackAddress().getCanonicalHostName().equals("localhost")) {
			login(user, password);
		}
	}

	public static void test(String user, String password) {
		Cookie adminCookie = getCookies()[0];
		// GOOD: login always happens
		if (adminCookie.getValue() == "false")
			login(user, password);
		else {
			login(user, password);
		}
	}

	public static void test2(String user, String password) {
		Cookie adminCookie = getCookies()[0];
		// BAD: login may happen once or twice
		if (adminCookie.getValue() == "false") // $ hasConditionalBypassTest
			login(user, password);
		else {
			// do something else
			doIt();
		}
		login(user, password);
	}

	public static void test3(String user, String password) {
		Cookie adminCookie = getCookies()[0];
		// BAD: login may not happen
		if (adminCookie.getValue() == "false") // $ hasConditionalBypassTest
			login(user, password);
		else {
			// do something else
			doIt();
		}
		return;
	}

	public static void test4(String user, String password) {
		Cookie adminCookie = getCookies()[0];
		// GOOD: login always happens
		if (adminCookie.getValue() == "false") {
			login(user, password);
			return;
		}

		// do other things
		login(user, password);
		return;
	}

	public static void test5(String user, String password) throws Exception {
		Cookie adminCookie = getCookies()[0];
		// GOOD: exit with Exception if condition is not met
		if (adminCookie.getValue() == "false") {
			throw new Exception();
		}

		login(user, password);
	}

	public static void test6(String user, String password) {
		Cookie adminCookie = getCookies()[0];
		// GOOD: exit with return if condition is not met
		if (adminCookie.getValue() == "false") {
			return;
		}

		login(user, password);
	}

	public static void test7(String user, String password) {
		Cookie adminCookie = getCookies()[0];
		// BAD: login is bypasseable
		if (adminCookie.getValue() == "false") { // $ hasConditionalBypassTest
			login(user, password);
			return;
		} else {
			doIt();
		}
	}

	public static void test8(String user, String password) {
		Cookie adminCookie = getCookies()[0];
		{
			// BAD: login may not happen
			if (adminCookie.getValue() == "false") // $ hasConditionalBypassTest
				authorize(user, password);
			else {
				// do something else
				doIt();
			}
		}
		{
			// obtainAuthor is not sensitive, so this is safe
			if (adminCookie.getValue() == "false")
				obtainAuthor();
			else {
				doIt();
			}
		}
	}

	public static void login(String user, String password) {
		// login
	}

	public static void reCheckAuth(String user, String password) {
		// login
	}

	public static void authorize(String user, String password) {
		// login
	}

	public static String obtainAuthor() {
		return "";
	}

	public static Cookie[] getCookies() {
		// get cookies from a servlet
		return new Cookie[0];
	}

	public static void doIt() {}

	public static void doReallyImportantSecurityWork() {
		// login, authenticate, everything
	}
}
