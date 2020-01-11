import java
import semmle.code.java.dataflow.FlowSources
import DataFlow

/** The class `com.unboundid.ldap.sdk.SearchRequest`. */
class TypeSearchRequest extends Class {
  TypeSearchRequest() { this.hasQualifiedName("com.unboundid.ldap.sdk", "SearchRequest") }
}

/** The class `com.unboundid.ldap.sdk.ReadOnlySearchRequest`. */
class TypeReadOnlySearchRequest extends Interface {
  TypeReadOnlySearchRequest() {
    this.hasQualifiedName("com.unboundid.ldap.sdk", "ReadOnlySearchRequest")
  }
}

/** The class `com.unboundid.ldap.sdk.Filter`. */
class TypeFilter extends Class {
  TypeFilter() { this.hasQualifiedName("com.unboundid.ldap.sdk", "Filter") }
}

/** The class `com.unboundid.ldap.sdk.LDAPConnection`. */
class TypeLDAPConnection extends Class {
  TypeLDAPConnection() { this.hasQualifiedName("com.unboundid.ldap.sdk", "LDAPConnection") }
}

/** The class `org.springframework.ldap.support.LdapEncoder`. */
class TypeLdapEncoder extends Class {
  TypeLdapEncoder() { this.hasQualifiedName("org.springframework.ldap.support", "LdapEncoder") }
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
    filterStep(node1, node2) or searchRequestStep(node1, node2)
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
    exists(MethodAccess ma, Method m, int index, RefType argType |
      ma.getMethod() = m and
      ma.getArgument(index) = this.getExpr() and
      ma.getArgument(index).getType() = argType
    |
      // LDAPConnection.search or LDAPConnection.searchForEntry method
      m.getDeclaringType() instanceof TypeLDAPConnection and
      (m.hasName("search") or m.hasName("searchForEntry")) and
      (
        // Parameter type is SearchRequest or ReadOnlySearchRequest
        (
          argType instanceof TypeReadOnlySearchRequest or
          argType instanceof TypeSearchRequest
        ) or
        // Or parameter index is 2, 3, 5, 6 or 7 (this is where filter parameter is)
        // but it's not the last one nor beyond the last one (varargs representing attributes)
        index = any(int i |
          (i = [2..3] or i = [5..7]) and i < ma.getMethod().getNumberOfParameters() - 1
        )
      )
    )
  }
}

/**
 * Spring LDAP sink for LDAP injection vulnerabilities,
 * i.e. LDAPConnection.search or LDAPConnection.searchForEntry method.
 */
 // LdapTemplate:
 // find(LdapQuery query, Class<T> clazz)
 // find(Name base, Filter filter, SearchControls searchControls, Class<T> clazz)
 // findOne(LdapQuery query, Class<T> clazz)
 // search - 2nd param if String (filter)
 // search - 1st param if LdapQuery
 // searchForContext(LdapQuery query)
 // searchForObject - 2nd param if String (filter)
 // searchForObject - 1st param if LdapQuery
class SpringLdapInjectionSink extends LdapInjectionSink {
  SpringLdapInjectionSink() {
    exists(MethodAccess ma, Method m, int index, RefType argType |
      ma.getMethod() = m and
      ma.getArgument(index) = this.getExpr() and
      ma.getArgument(index).getType() = argType
    |
      // LDAPConnection.search or LDAPConnection.searchForEntry method
      m.getDeclaringType() instanceof TypeLDAPConnection and
      (m.hasName("search") or m.hasName("searchForEntry")) and
      (
        // Parameter type is SearchRequest or ReadOnlySearchRequest
        (
          argType instanceof TypeReadOnlySearchRequest or
          argType instanceof TypeSearchRequest
        ) or
        // Or parameter index is 2, 3, 5, 6 or 7 (this is where filter parameter is)
        // but it's not the last one nor beyond the last one (varargs representing attributes)
        index = any(int i |
          (i = [2..3] or i = [5..7]) and i < ma.getMethod().getNumberOfParameters() - 1
        )
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
    this.getType() instanceof TypeFilter and
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
    m.getDeclaringType() instanceof TypeFilter and
    m.hasName("create")
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and UnboundID
 * `SearchRequest`, i.e. `new SearchRequest([...], tainted, [...])`, where `tainted` is
 * parameter number 3, 4, 7, 8 or 9, but not the last one or beyond the last one (varargs).
 */
predicate searchRequestStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc, int index | cc.getConstructedType() instanceof TypeSearchRequest |
    n1.asExpr() = cc.getArgument(index) and
    n2.asExpr() = cc and
    index = any(int i |
      (i = [2..3] or i = [6..8]) and i < cc.getConstructor().getNumberOfParameters() - 1
    )
  )
}