import java
import semmle.code.java.dataflow.FlowSources
import DataFlow

/** The interface `javax.naming.directory.DirContext`. */
class TypeDirContext extends Interface {
  TypeDirContext() { this.hasQualifiedName("javax.naming.directory", "DirContext") }
}

/** The interface `javax.naming.ldap.LdapContext`. */
class TypeLdapContext extends Interface {
  TypeLdapContext() { this.hasQualifiedName("javax.naming.ldap", "LdapContext") }
}

/** The class `javax.naming.ldap.LdapName`. */
class TypeLdapName extends Class {
  TypeLdapName() { this.hasQualifiedName("javax.naming.ldap", "LdapName") }
}

/** The interface `com.unboundid.ldap.sdk.ReadOnlySearchRequest`. */
class TypeReadOnlySearchRequest extends Interface {
  TypeReadOnlySearchRequest() {
    this.hasQualifiedName("com.unboundid.ldap.sdk", "ReadOnlySearchRequest")
  }
}

/** The class `com.unboundid.ldap.sdk.SearchRequest`. */
class TypeUnboundIdSearchRequest extends Class {
  TypeUnboundIdSearchRequest() { this.hasQualifiedName("com.unboundid.ldap.sdk", "SearchRequest") }
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

/** The class `org.springframework.ldap.query.LdapQueryBuilder`. */
class TypeLdapQueryBuilder extends Class {
  TypeLdapQueryBuilder() {
    this.hasQualifiedName("org.springframework.ldap.query", "LdapQueryBuilder")
  }
}

/** The interface `org.springframework.ldap.query.ConditionCriteria`. */
class TypeConditionCriteria extends Interface {
  TypeConditionCriteria() {
    this.hasQualifiedName("org.springframework.ldap.query", "ConditionCriteria")
  }
}

/** The interface `org.springframework.ldap.query.ContainerCriteria`. */
class TypeContainerCriteria extends Interface {
  TypeContainerCriteria() {
    this.hasQualifiedName("org.springframework.ldap.query", "ContainerCriteria")
  }
}

/** The class `org.springframework.ldap.filter.HardcodedFilter`. */
class TypeHardcodedFilter extends Class {
  TypeHardcodedFilter() {
    this.hasQualifiedName("org.springframework.ldap.filter", "HardcodedFilter")
  }
}

/** The interface `org.springframework.ldap.filter.Filter`. */
class TypeSpringLdapFilter extends Interface {
  TypeSpringLdapFilter() { this.hasQualifiedName("org.springframework.ldap.filter", "Filter") }
}

/** The class `org.springframework.ldap.support.LdapNameBuilder`. */
class TypeLdapNameBuilder extends Class {
  TypeLdapNameBuilder() {
    this.hasQualifiedName("org.springframework.ldap.support", "LdapNameBuilder")
  }
}

/** The class `org.springframework.ldap.support.LdapUtils`. */
class TypeLdapUtils extends Class {
  TypeLdapUtils() { this.hasQualifiedName("org.springframework.ldap.support", "LdapUtils") }
}

/** The interface `org.apache.directory.ldap.client.api.LdapConnection`. */
class TypeLdapConnection extends Interface {
  TypeLdapConnection() {
    this.hasQualifiedName("org.apache.directory.ldap.client.api", "LdapConnection")
  }
}

/** The interface `org.apache.directory.api.ldap.model.message.SearchRequest`. */
class TypeApacheSearchRequest extends Interface {
  TypeApacheSearchRequest() {
    this.hasQualifiedName("org.apache.directory.api.ldap.model.message", "SearchRequest")
  }
}

/** The class `org.apache.directory.api.ldap.model.name.Dn`. */
class TypeApacheDn extends Class {
  TypeApacheDn() {
    this.hasQualifiedName("org.apache.directory.api.ldap.model.name", "Dn")
  }
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
    ldapNameStep(node1, node2) or
    ldapNameAddAllStep(node1, node2) or
    ldapNameGetCloneStep(node1, node2) or
    filterStep(node1, node2) or
    filterToStringStep(node1, node2) or
    unboundIdSearchRequestStep(node1, node2) or
    unboundIdSearchRequestDuplicateStep(node1, node2) or
    unboundIdSearchRequestSetStep(node1, node2) or
    ldapQueryStep(node1, node2) or
    ldapQueryBaseStep(node1, node2) or
    ldapQueryBuilderStep(node1, node2) or
    hardcodedFilterStep(node1, node2) or
    springLdapFilterToStringStep(node1, node2) or
    ldapNameBuilderStep(node1, node2) or
    ldapNameBuilderBuildStep(node1, node2) or
    ldapUtilsStep(node1, node2) or
    apacheSearchRequestStep(node1, node2) or
    apacheSearchRequestGetStep(node1, node2) or
    apacheLdapDnStep(node1, node2) or
    apacheLdapDnGetStep(node1, node2)
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

/**
 * JNDI sink for LDAP injection vulnerabilities, i.e. 1st (DN) or 2nd (filter) argument to
 * `search` method from `DirContext` or `LdapContext`.
 */
class JndiLdapInjectionSink extends LdapInjectionSink {
  JndiLdapInjectionSink() {
    exists(MethodAccess ma, Method m, int index |
      ma.getMethod() = m and
      ma.getArgument(index) = this.getExpr()
    |
      (
        m.getDeclaringType().getAnAncestor() instanceof TypeDirContext or
        m.getDeclaringType().getAnAncestor() instanceof TypeLdapContext
      ) and
      m.hasName("search") and
      index in [0..1]
    )
  }
}

/**
 * UnboundID sink for LDAP injection vulnerabilities,
 * i.e. LDAPConnection.search, LDAPConnection.asyncSearch or LDAPConnection.searchForEntry method.
 */
class UnboundIdLdapInjectionSink extends LdapInjectionSink {
  UnboundIdLdapInjectionSink() {
    exists(MethodAccess ma, Method m, int index, Parameter param |
      ma.getMethod() = m and
      ma.getArgument(index) = this.getExpr() and
      m.getParameter(index) = param
    |
      // LDAPConnection.search, LDAPConnection.asyncSearch or LDAPConnection.searchForEntry method
      m.getDeclaringType() instanceof TypeLDAPConnection and
      (m.hasName("search") or m.hasName("asyncSearch") or m.hasName("searchForEntry")) and
      // Parameter is not varargs
      not isVarargs(m, index)
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
        // Parameter index is 1 (DN or query) or 2 (filter) if method is not authenticate
        (index in [0..1] and not m.hasName("authenticate")) or
        // But it's not the last parameter in case of authenticate method (last param is password)
        (index in [0..1] and index < m.getNumberOfParameters() - 1 and m.hasName("authenticate"))
      )
    )
  }
}

/** Apache LDAP API sink for LDAP injection vulnerabilities, i.e. LdapConnection.search method. */
class ApacheLdapInjectionSink extends LdapInjectionSink {
  ApacheLdapInjectionSink() {
    exists(MethodAccess ma, Method m, int index, RefType paramType |
      ma.getMethod() = m and
      ma.getArgument(index) = this.getExpr() and
      m.getParameterType(index) = paramType
    |
      m.getDeclaringType().getAnAncestor() instanceof TypeLdapConnection and
      m.hasName("search") and
      not isVarargs(m, index)
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
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `LdapName`,
 * i.e. `new LdapName(tainted)`.
 */
predicate ldapNameStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeLdapName |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `List<Rdn>` and `LdapName`,
 * i.e. `new LdapName().addAll(tainted)`.
 */
predicate ldapNameAddAllStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getAnArgument() and
    (n2.asExpr() = ma or n2.asExpr() = ma.getQualifier())
  |
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeLdapName and
    m.hasName("addAll")
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `LdapName` and `LdapName` or
 * `String`, i.e. `taintedLdapName.clone()`, `taintedLdapName.getAll()`,
 * `taintedLdapName.getRdns()` or `taintedLdapName.toString()`.
 */
predicate ldapNameGetCloneStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma
  |
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeLdapName and
    (m.hasName("clone") or m.hasName("getAll") or m.hasName("getRdns") or m.hasName("toString"))
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and UnboundID `Filter`,
 * i.e. `Filter.create*(tainted)`.
 */
predicate filterStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getAnArgument()
  |
    n2.asExpr() = ma and
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeUnboundIdLdapFilter and
    (
      m.hasName("create") or
      m.hasName("createANDFilter") or
      m.hasName("createNOTFilter") or
      m.hasName("createORFilter") or
      m.hasName("simplifyFilter")
    )
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between UnboundID `Filter` and `String`,
 * i.e. `taintedFilter.toString()` or `taintedFilter.toString(buffer)`.
 */
predicate filterToStringStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getQualifier() and
    (n2.asExpr() = ma or n2.asExpr() = ma.getAnArgument())
  |
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeUnboundIdLdapFilter and
    (m.hasName("toString") or m.hasName("toNormalizedString"))
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and UnboundID
 * `SearchRequest`, i.e. `new SearchRequest(tainted)`.
 */
predicate unboundIdSearchRequestStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc, Constructor c, int index |
    cc.getConstructedType() instanceof TypeUnboundIdSearchRequest
  |
    n1.asExpr() = cc.getArgument(index) and
    n2.asExpr() = cc and
    c = cc.getConstructor() and
    not isVarargs(c, index)
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between UnboundID `SearchRequest`
 * and UnboundID `SearchRequest`, i.e. `taintedSearchRequest.duplicate()`.
 */
predicate unboundIdSearchRequestDuplicateStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma
  |
    ma.getMethod() = m and
    m.getDeclaringType().getAnAncestor() instanceof TypeReadOnlySearchRequest and
    m.hasName("duplicate")
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between DN or filter and UnboundID
 * `SearchRequest`, i.e. `searchRequest.setBaseDN(tainted)` or `searchRequest.setFilter(tainted)`.
 */
predicate unboundIdSearchRequestSetStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getAnArgument() and
    n2.asExpr() = ma.getQualifier()
  |
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeUnboundIdSearchRequest and
    (m.hasName("setBaseDN") or m.hasName("setFilter"))
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and Spring `LdapQuery`,
 * i.e. `LdapQueryBuilder.query().filter(tainted)` or `LdapQueryBuilder.query().base(tainted)`.
 */
predicate ldapQueryStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m, int index |
    n1.asExpr() = ma.getArgument(index)
  |
    n2.asExpr() = ma and
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeLdapQueryBuilder and
    (m.hasName("filter") or m.hasName("base")) and
    index = 0
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between Spring `LdapQueryBuilder` and
 * `Name`, i.e. `taintedLdapQueryBuilder.base()`.
 */
predicate ldapQueryBaseStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma
  |
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeLdapQueryBuilder and
    m.hasName("base") and
    m.getNumberOfParameters() = 0
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between Spring `LdapQueryBuilder`,
 * `ConditionCriteria` or `ContainerCriteria`, i.e. when the query is built, for example
 * `query().base(tainted).where("objectclass").is("person")`.
 */
predicate ldapQueryBuilderStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma
  |
    ma.getMethod() = m and
    (
      m.getDeclaringType() instanceof TypeLdapQueryBuilder or
      m.getDeclaringType() instanceof TypeConditionCriteria or
      m.getDeclaringType() instanceof TypeContainerCriteria
    ) and
    (
      m.getReturnType() instanceof TypeLdapQueryBuilder or
      m.getReturnType() instanceof TypeConditionCriteria or
      m.getReturnType() instanceof TypeContainerCriteria
    )
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

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between Spring `Filter` and
 * `String`, i.e. `taintedFilter.toString()`, `taintedFilter.encode()` or
 * `taintedFilter.encode(buffer)`.
 */
predicate springLdapFilterToStringStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getQualifier() and
    (n2.asExpr() = ma or n2.asExpr() = ma.getAnArgument())
  |
    ma.getMethod() = m and
    m.getDeclaringType().getAnAncestor() instanceof TypeSpringLdapFilter and
    (m.hasName("encode") or m.hasName("toString"))
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and Spring
 * `LdapNameBuilder`, i.e. `LdapNameBuilder.newInstance(tainted)` or
 * `LdapNameBuilder.newInstance().add(tainted)`.
 */
predicate ldapNameBuilderStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m | n1.asExpr() = ma.getAnArgument() |
    (n2.asExpr() = ma or n2.asExpr() = ma.getQualifier()) and
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeLdapNameBuilder and
    (m.hasName("newInstance") or m.hasName("add")) and
    m.getNumberOfParameters() = 1
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between tainted Spring `LdapNameBuilder`
 * and `LdapName`, `LdapNameBuilder.build()`.
 */
predicate ldapNameBuilderBuildStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m | n1.asExpr() = ma.getQualifier() |
    n2.asExpr() = ma and
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeLdapNameBuilder and
    m.hasName("build")
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `LdapName` via
 * Spring `LdapUtils.newLdapName`, i.e. `LdapUtils.newLdapName(tainted)`.
 */
predicate ldapUtilsStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m | n1.asExpr() = ma.getAnArgument() |
    n2.asExpr() = ma and
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeLdapUtils and
    m.hasName("newLdapName")
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and Apache LDAP API
 * `SearchRequest`, i.e. `searchRequest.setFilter(tainted)` or `searchRequest.setBase(tainted)`.
 */
predicate apacheSearchRequestStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getAnArgument() and
    n2.asExpr() = ma.getQualifier()
  |
    ma.getMethod() = m and
    m.getDeclaringType().getAnAncestor() instanceof TypeApacheSearchRequest and
    (m.hasName("setFilter") or m.hasName("setBase"))
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between Apache LDAP API `SearchRequest`
 * and filter or DN i.e. `tainterSearchRequest.getFilter()` or `taintedSearchRequest.getBase()`.
 */
predicate apacheSearchRequestGetStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma
  |
    ma.getMethod() = m and
    m.getDeclaringType().getAnAncestor() instanceof TypeApacheSearchRequest and
    (m.hasName("getFilter") or m.hasName("getBase"))
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and Apache LDAP API
 * `Dn`, i.e. `new Dn(tainted)`.
 */
predicate apacheLdapDnStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeApacheDn |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between Apache LDAP API `Dn`
 * and `String` i.e. `taintedDn.getName()`, `taintedDn.getNormName()` or `taintedDn.toString()`.
 */
predicate apacheLdapDnGetStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma
  |
    ma.getMethod() = m and
    m.getDeclaringType().getAnAncestor() instanceof TypeApacheDn and
    (m.hasName("getName") or m.hasName("getNormName") or m.hasName("toString"))
  )
}