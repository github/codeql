/** Provides classes to reason about LDAP injection attacks. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Jndi
import semmle.code.java.frameworks.UnboundId
import semmle.code.java.frameworks.SpringLdap
import semmle.code.java.frameworks.ApacheLdap

/** A data flow sink for unvalidated user input that is used to construct LDAP queries. */
abstract class LdapInjectionSink extends DataFlow::Node { }

/** A class that identifies sanitizers that prevent LDAP injection attacks. */
abstract class LdapInjectionSanitizer extends DataFlow::Node { }

private predicate jndiLdapInjectionSinkMethod(Method m, int index) {
  m.getDeclaringType().getAnAncestor() instanceof TypeDirContext and
  m.hasName("search") and
  index in [0 .. 1]
}

/**
 * JNDI sink for LDAP injection vulnerabilities, i.e. 1st (DN) or 2nd (filter) argument to
 * `search` method from `DirContext`.
 */
private class JndiLdapInjectionSink extends LdapInjectionSink {
  JndiLdapInjectionSink() {
    exists(MethodAccess ma, Method m, int index |
      ma.getMethod() = m and
      ma.getArgument(index) = this.asExpr() and
      jndiLdapInjectionSinkMethod(m, index)
    )
  }
}

private predicate unboundIdLdapInjectionSinkMethod(Method m, int index) {
  exists(Parameter param | m.getParameter(index) = param and not param.isVarargs() |
    m instanceof MethodUnboundIdLDAPConnectionSearch or
    m instanceof MethodUnboundIdLDAPConnectionAsyncSearch or
    m instanceof MethodUnboundIdLDAPConnectionSearchForEntry
  )
}

/**
 * UnboundID sink for LDAP injection vulnerabilities,
 * i.e. LDAPConnection.search, LDAPConnection.asyncSearch or LDAPConnection.searchForEntry method.
 */
private class UnboundedIdLdapInjectionSink extends LdapInjectionSink {
  UnboundedIdLdapInjectionSink() {
    exists(MethodAccess ma, Method m, int index |
      ma.getMethod() = m and
      ma.getArgument(index) = this.asExpr() and
      unboundIdLdapInjectionSinkMethod(m, index)
    )
  }
}

private predicate springLdapInjectionSinkMethod(Method m, int index) {
  // LdapTemplate.authenticate, LdapTemplate.find* or LdapTemplate.search* method
  (
    m instanceof MethodSpringLdapTemplateAuthenticate or
    m instanceof MethodSpringLdapTemplateFind or
    m instanceof MethodSpringLdapTemplateFindOne or
    m instanceof MethodSpringLdapTemplateSearch or
    m instanceof MethodSpringLdapTemplateSearchForContext or
    m instanceof MethodSpringLdapTemplateSearchForObject
  ) and
  (
    // Parameter index is 1 (DN or query) or 2 (filter) if method is not authenticate
    index in [0 .. 1] and
    not m instanceof MethodSpringLdapTemplateAuthenticate
    or
    // But it's not the last parameter in case of authenticate method (last param is password)
    index in [0 .. 1] and
    index < m.getNumberOfParameters() - 1 and
    m instanceof MethodSpringLdapTemplateAuthenticate
  )
}

/**
 * Spring LDAP sink for LDAP injection vulnerabilities,
 * i.e. LdapTemplate.authenticate, LdapTemplate.find* or LdapTemplate.search* method.
 */
private class SpringLdapInjectionSink extends LdapInjectionSink {
  SpringLdapInjectionSink() {
    exists(MethodAccess ma, Method m, int index |
      ma.getMethod() = m and
      ma.getArgument(index) = this.asExpr() and
      springLdapInjectionSinkMethod(m, index)
    )
  }
}

private predicate apacheLdapInjectionSinkMethod(Method m, int index) {
  exists(Parameter param | m.getParameter(index) = param and not param.isVarargs() |
    m.getDeclaringType().getAnAncestor() instanceof TypeApacheLdapConnection and
    m.hasName("search")
  )
}

/** Apache LDAP API sink for LDAP injection vulnerabilities, i.e. LdapConnection.search method. */
private class ApacheLdapInjectionSink extends LdapInjectionSink {
  ApacheLdapInjectionSink() {
    exists(MethodAccess ma, Method m, int index |
      ma.getMethod() = m and
      ma.getArgument(index) = this.asExpr() and
      apacheLdapInjectionSinkMethod(m, index)
    )
  }
}

/** A sanitizer that clears the taint on primitive types. */
private class PrimitiveTypeLdapSanitizer extends LdapInjectionSanitizer {
  PrimitiveTypeLdapSanitizer() { this.getType() instanceof PrimitiveType }
}

/** A sanitizer that clears the taint on boxed primitive types. */
private class BoxedTypeLdapSanitizer extends LdapInjectionSanitizer {
  BoxedTypeLdapSanitizer() { this.getType() instanceof BoxedType }
}
