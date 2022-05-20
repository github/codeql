// Test case for CWE-807 (Reliance on Untrusted Inputs in a Security Decision)
// http://cwe.mitre.org/data/definitions/807.html
package test.cwe807.semmle.tests;

import javax.servlet.http.HttpServletRequest;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;

class TaintedPermissionsCheckTest {
	public static void main(HttpServletRequest request) throws Exception {
		// Apache Shiro permissions system
		String action = request.getParameter("action");
		Subject subject = SecurityUtils.getSubject();
		// BAD: permissions decision made using tainted data
		if (subject.isPermitted("domain:sublevel:" + action))
			doIt();

		// GOOD: use fixed checks
		if (subject.isPermitted("domain:sublevel:whatTheMethodDoes"))
			doIt();
	}

	public static void doIt() {}

}
