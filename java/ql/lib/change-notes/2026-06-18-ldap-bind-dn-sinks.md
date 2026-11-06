---
category: minorAnalysis
---
* Added LDAP bind-DN sinks to the `java/ldap-injection` query: the `String name` argument of `javax.naming.Context` / `javax.naming.directory.DirContext` `bind`, `rebind`, `lookup`, `lookupLink`, and `createSubcontext`; the `java.naming.security.principal` JNDI environment value; and the `principal` argument of Apache Shiro `LdapContextFactory.getLdapContext`. The query now detects LDAP distinguished-name injection (CWE-90) into a bind DN, not just into a search filter or search base. `new javax.naming.ldap.LdapName(String)` is deliberately not modelled as a sink, as it commonly parses an existing certificate or principal DN rather than constructing one for a bind.
