// Test case for CWE-807 (Reliance on Untrusted Inputs in a Security Decision)
// http://cwe.mitre.org/data/definitions/807.html
package test.cwe807.semmle.tests;




import java.net.InetAddress;
import java.net.Inet4Address;
import java.net.UnknownHostException;

import javax.servlet.http.Cookie;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;

class Test {
	public static void main(String[] args) throws UnknownHostException {
		String user = args[0];
		String password = args[1];
		
		String isAdmin = args[3];
		
		// BAD: login is only executed if isAdmin is false, but isAdmin
		// is controlled by the user
		if(isAdmin=="false")
			login(user, password);
		
		Cookie adminCookie = getCookies()[0];
		// BAD: login is only executed if the cookie value is false, but the cookie
		// is controlled by the user
		if(adminCookie.getValue().equals("false"))
			login(user, password);
		
		// FALSE POSITIVES: both methods are conditionally executed, but they probably
		// both perform the security-critical action
		if(adminCookie.getValue()=="false") {
			login(user, password);
		} else {
			reCheckAuth(user, password);
		}
		
		// FALSE NEGATIVE: we have no way of telling that the skipped method is sensitive
		if(adminCookie.getValue()=="false")
			doReallyImportantSecurityWork();
		
		// Apache Shiro permissions system
		String whatDoTheyWantToDo = args[4];
		Subject subject = SecurityUtils.getSubject();
		// BAD: permissions decision made using tainted data
		if(subject.isPermitted("domain:sublevel:" + whatDoTheyWantToDo))
			doIt();
		
		// GOOD: use fixed checks
		if(subject.isPermitted("domain:sublevel:whatTheMethodDoes"))
			doIt();
		
		InetAddress local = InetAddress.getLocalHost();
		// GOOD: reverse DNS on localhost is fine
		if (local.getCanonicalHostName().equals("localhost")) {
			login(user, password);
		}
		if (Inet4Address.getLocalHost().getCanonicalHostName().equals("localhost")) {
			login(user, password);
		}
	}
	
	public static void test(String user, String password) {
		Cookie adminCookie = getCookies()[0];
		// GOOD: login always happens
		if(adminCookie.getValue()=="false")
			login(user, password);
		else {
			// do something else
			login(user, password);
		}
	}
	
	public static void test2(String user, String password) {
		Cookie adminCookie = getCookies()[0];
		// BAD: login may happen once or twice
		if(adminCookie.getValue()=="false")
			login(user, password);
		else {
			// do something else
		}
		login(user, password);
	}
	
	public static void test3(String user, String password) {
		Cookie adminCookie = getCookies()[0];
		if(adminCookie.getValue()=="false")
			login(user, password);
		else {
			// do something else
			// BAD: login may not happen
			return;
		}
	}
	
	public static void test4(String user, String password) {
		Cookie adminCookie = getCookies()[0];
		// GOOD: login always happens
		if(adminCookie.getValue()=="false") {
			login(user, password);
			return;
		}
		
		// do other things
		login(user, password);
		return;
	}
	
	public static void login(String user, String password) {
		// login
	}
	
	public static void reCheckAuth(String user, String password) {
		// login
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
