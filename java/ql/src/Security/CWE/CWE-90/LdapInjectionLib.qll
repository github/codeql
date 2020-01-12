import java
import semmle.code.java.dataflow.FlowSources
import DataFlow

/** The class `com.unboundid.ldap.sdk.SearchRequest`. */
class TypeSearchRequest extends Class {
  TypeSearchRequest() { this.hasQualifiedName("com.unboundid.ldap.sdk", "SearchRequest") }
}

/** The interface `com.unboundid.ldap.sdk.ReadOnlySearchRequest`. */
class TypeReadOnlySearchRequest extends Interface {
  TypeReadOnlySearchRequest() {
    this.hasQualifiedName("com.unboundid.ldap.sdk", "ReadOnlySearchRequest")
  }
}

/** The class `com.unboundid.ldap.sdk.Filter`. */
class TypeUnboundIdLdapFilter extends Class {
  TypeUnboundIdLdapFilter() { this.hasQualifiedName("com.unboundid.ldap.sdk", "Filter") }
}

/** The class `com.unboundid.ldap.sdk.LDAPConnection`. */
class TypeLDAPConnection extends Class {
  TypeLDAPConnection() { this.hasQualifiedName("com.unboundid.ldap.sdk", "LDAPConnection") }
}

/** The class `org.springframework.ldap.core.LdapTemplate`. */
class TypeLdapTemplate extends Class {
  TypeLdapTemplate() { this.hasQualifiedName("org.springframework.ldap.core", "LdapTemplate") }
}

/** The interface `org.springframework.ldap.query.LdapQuery`. */
class TypeLdapQuery extends Interface {
  TypeLdapQuery() { this.hasQualifiedName("org.springframework.ldap.query", "LdapQuery") }
}

/** The interface `org.springframework.ldap.query.LdapQueryBuilder`. */
class TypeLdapQueryBuilder extends Class {
  TypeLdapQueryBuilder() {
    this.hasQualifiedName("org.springframework.ldap.query", "LdapQueryBuilder")
  }
}

/** The interface `org.springframework.ldap.filter.HardcodedFilter`. */
class TypeHardcodedFilter extends Class {
  TypeHardcodedFilter() {
    this.hasQualifiedName("org.springframework.ldap.filter", "HardcodedFilter")
  }
}

/** The interface `org.springframework.ldap.filter.Filter`. */
class TypeSpringLdapFilter extends Interface {
  TypeSpringLdapFilter() { this.hasQualifiedName("org.springframework.ldap.filter", "Filter") }
}

/** The class `org.springframework.ldap.support.LdapEncoder`. */
class TypeLdapEncoder extends Class {
  TypeLdapEncoder() { this.hasQualifiedName("org.springframework.ldap.support", "LdapEncoder") }
}

/** Holds if the parameter of `c` at index `paramIndex` is varargs. */
bindingset[paramIndex]
predicate isVarargs(Callable c, int paramIndex) {
  c.getParameter(min(int i | i = paramIndex or i = c.getNumberOfParameters() - 1 | i)).isVarargs()
}

/** A data flow source for unvalidated user input that is used to construct LDAP queries. */
abstract class LdapInjectionSource extends DataFlow::Node { }

/** A data flow sink for unvalidated user input that is used to construct LDAP queries. */
abstract class LdapInjectionSink extends DataFlow::ExprNode { }

/** A sanitizer for unvalidated user input that is used to construct LDAP queries. */
abstract class LdapInjectionSanitizer extends DataFlow::ExprNode { }

/**
* A taint-tracking configuration for unvalidated user input that is used to construct LDAP queries.
*/
class LdapInjectionFlowConfig extends TaintTracking::Configuration {
  LdapInjectionFlowConfig() { this = "LdapInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof LdapInjectionSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof LdapInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof LdapInjectionSanitizer }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    filterStep(node1, node2) or
    searchRequestStep(node1, node2) or
    ldapQueryStep(node1, node2) or
    hardcodedFilterStep(node1, node2)
  }
}

/** A source of remote user input. */
class RemoteSource extends LdapInjectionSource {
  RemoteSource() { this instanceof RemoteFlowSource }
}

/** A source of local user input. */
class LocalSource extends LdapInjectionSource {
  LocalSource() { this instanceof LocalUserInput }
}

abstract class Context extends RefType { }

/**
 * The interface `javax.naming.directory.DirContext` or
 * the class `javax.naming.directory.InitialDirContext`.
 */
class DirContext extends Context {
  DirContext() {
    this.hasQualifiedName("javax.naming.directory", "DirContext") or
    this.hasQualifiedName("javax.naming.directory", "InitialDirContext")
  }
}

/**
 * The interface `javax.naming.ldap.LdapContext` or
 * the class `javax.naming.ldap.InitialLdapContext`.
 */
class LdapContext extends Context {
  LdapContext() {
    this.hasQualifiedName("javax.naming.ldap", "LdapContext") or
    this.hasQualifiedName("javax.naming.ldap", "InitialLdapContext")
  }
}

/**
 * JNDI sink for LDAP injection vulnerabilities, i.e. 2nd argument to search method from
 * DirContext, InitialDirContext, LdapContext or InitialLdapContext.
 */
class JndiLdapInjectionSink extends LdapInjectionSink {
  JndiLdapInjectionSink() {
    exists(MethodAccess ma, Method m, int index |
      ma.getMethod() = m and
      ma.getArgument(index) = this.getExpr()
    |
      m.getDeclaringType() instanceof Context and m.hasName("search") and index = 1
    )
  }
}

/**
 * UnboundID sink for LDAP injection vulnerabilities,
 * i.e. LDAPConnection.search or LDAPConnection.searchForEntry method.
 */
class UnboundIdLdapInjectionSink extends LdapInjectionSink {
  UnboundIdLdapInjectionSink() {
    exists(MethodAccess ma, Method m, int index, Parameter param |
      ma.getMethod() = m and
      ma.getArgument(index) = this.getExpr() and
      m.getParameter(index) = param
    |
      // LDAPConnection.search or LDAPConnection.searchForEntry method
      m.getDeclaringType() instanceof TypeLDAPConnection and
      (m.hasName("search") or m.hasName("searchForEntry")) and
      // Parameter is not varargs
      not isVarargs(m, index) and
      (
        // Parameter type is SearchRequest or ReadOnlySearchRequest
        param.getType() instanceof TypeReadOnlySearchRequest or
        param.getType() instanceof TypeSearchRequest or
        // Or parameter index is 2, 3, 5, 6 or 7 (this is where filter parameter is)
        index = any(int i | i = [2..3] or i = [5..7])
      )
    )
  }
}

/**
 * Spring LDAP sink for LDAP injection vulnerabilities,
 * i.e. LdapTemplate.authenticate, LdapTemplate.find* or LdapTemplate.search* method.
 */
class SpringLdapInjectionSink extends LdapInjectionSink {
  SpringLdapInjectionSink() {
    exists(MethodAccess ma, Method m, int index, RefType paramType |
      ma.getMethod() = m and
      ma.getArgument(index) = this.getExpr() and
      m.getParameterType(index) = paramType
    |
      // LdapTemplate.authenticate, LdapTemplate.find* or LdapTemplate.search* method
      m.getDeclaringType() instanceof TypeLdapTemplate and
      (
        m.hasName("authenticate") or
        m.hasName("find") or
        m.hasName("findOne") or
        m.hasName("search") or
        m.hasName("searchForContext") or
        m.hasName("searchForObject")
      ) and
      (
        // Parameter type is LdapQuery or Filter
        paramType instanceof TypeLdapQuery or
        paramType instanceof TypeSpringLdapFilter or
        // Or parameter index is 1 (this is where filter parameter is)
        index = 1
      )
    )
  }
}

/** An expression node with a primitive type. */
class PrimitiveTypeSanitizer extends LdapInjectionSanitizer {
  PrimitiveTypeSanitizer() { this.getType() instanceof PrimitiveType }
}

/** An expression node with a boxed type. */
class BoxedTypeSanitizer extends LdapInjectionSanitizer {
  BoxedTypeSanitizer() { this.getType() instanceof BoxedType }
}

/** encodeForLDAP and encodeForDN from OWASP ESAPI. */
class EsapiSanitizer extends LdapInjectionSanitizer {
  EsapiSanitizer() {
    this.getExpr().(MethodAccess).getMethod().hasName("encodeForLDAP")
   }
}

/** LdapEncoder.filterEncode and LdapEncoder.nameEncode from Spring LDAP. */
class SpringLdapSanitizer extends LdapInjectionSanitizer {
  SpringLdapSanitizer() {
    this.getType() instanceof TypeLdapEncoder and
    this.getExpr().(MethodAccess).getMethod().hasName("filterEncode")
   }
}

/** Filter.encodeValue from UnboundID. */
class UnboundIdSanitizer extends LdapInjectionSanitizer {
  UnboundIdSanitizer() {
    this.getType() instanceof TypeUnboundIdLdapFilter and
    this.getExpr().(MethodAccess).getMethod().hasName("encodeValue")
   }
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and UnboundID `Filter`,
 * i.e. `Filter.create(tainted)`.
 */
predicate filterStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getQualifier() or
    n1.asExpr() = ma.getAnArgument()
  |
    n2.asExpr() = ma and
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeUnboundIdLdapFilter and
    m.hasName("create")
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and UnboundID
 * `SearchRequest`, i.e. `new SearchRequest([...], tainted, [...])`, where `tainted` is
 * parameter number 3, 4, 7, 8 or 9, but is not varargs.
 */
predicate searchRequestStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc, Constructor c, int index |
    cc.getConstructedType() instanceof TypeSearchRequest
  |
    n1.asExpr() = cc.getArgument(index) and
    n2.asExpr() = cc and
    c = cc.getConstructor() and
    // not c.getParameter(min(int i | i = index or i = c.getNumberOfParameters() - 1 | i)).isVarargs() and
    not isVarargs(c, index) and
    index = any(int i |i = [2..3] or i = [6..8])
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and Spring `LdapQuery`,
 * i.e. `LdapQueryBuilder.query().filter(tainted)`.
 */
predicate ldapQueryStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m, int index |
    n1.asExpr() = ma.getQualifier() or
    n1.asExpr() = ma.getArgument(index)
  |
    n2.asExpr() = ma and
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeLdapQueryBuilder and
    m.hasName("filter") and
    index = 0
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and Spring
 * `HardcodedFilter`, i.e. `new HardcodedFilter(tainted)`.
 */
predicate hardcodedFilterStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeHardcodedFilter |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}