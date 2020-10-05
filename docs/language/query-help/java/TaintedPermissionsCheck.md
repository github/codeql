# User-controlled data used in permissions check

```
ID: java/tainted-permissions-check
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-807 external/cwe/cwe-290

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-807/TaintedPermissionsCheck.ql)

Using user-controlled data in a permissions check may allow a user to gain unauthorized access to protected functionality or data.


## Recommendation
When checking whether a user is authorized for a particular activity, do not use data that is controlled by that user in the permissions check. If necessary, always validate the input, ideally against a fixed list of expected values.

Similarly, do not decide which permission to check for based on user data. In particular, avoid using computation to decide which permissions to check for. Use fixed permissions for particular actions, rather than generating the permission to check for.


## Example
This example, using the Apache Shiro security framework, shows two ways to specify the permissions to check. The first way uses a string, `whatDoTheyWantToDo`, to specify the permissions to check. However, this string is built from user input. This can allow an attacker to force a check against a permission that they know they have, rather than the permission that should be checked. For example, while trying to access the account details of another user, the attacker could force the system to check whether they had permissions to access their *own* account details, which is incorrect, and would allow them to perform the action. The second, more secure way uses a fixed check that does not depend on data that is controlled by the user.


```java
public static void main(String[] args) {
	String whatDoTheyWantToDo = args[0];
	Subject subject = SecurityUtils.getSubject();

	// BAD: permissions decision made using tainted data
	if(subject.isPermitted("domain:sublevel:" + whatDoTheyWantToDo))
		doIt();

	// GOOD: use fixed checks
	if(subject.isPermitted("domain:sublevel:whatTheMethodDoes"))
		doIt();
}
```

## References
* The CERT Oracle Secure Coding Standard for Java: [SEC02-J. Do not base security checks on untrusted sources](https://www.securecoding.cert.org/confluence/display/java/SEC02-J.+Do+not+base+security+checks+on+untrusted+sources).
* Common Weakness Enumeration: [CWE-807](https://cwe.mitre.org/data/definitions/807.html).
* Common Weakness Enumeration: [CWE-290](https://cwe.mitre.org/data/definitions/290.html).