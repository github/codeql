import java
import semmle.code.java.dataflow.FlowSources
import DataFlow
import semmle.code.java.frameworks.Jndi
import semmle.code.java.frameworks.UnboundId
import semmle.code.java.frameworks.SpringLdap
import semmle.code.java.frameworks.ApacheLdap

/**
 * A taint-tracking configuration for unvalidated user input that is used to construct LDAP queries.
 */
class LdapInjectionFlowConfig extends TaintTracking::Configuration {
  LdapInjectionFlowConfig() { this = "LdapInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof LdapInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }

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

/**
 * JNDI sink for LDAP injection vulnerabilities, i.e. 1st (DN) or 2nd (filter) argument to
 * `search` method from `DirContext`.
 */
predicate jndiLdapInjectionSinkMethod(Method m, int index) {
  m.getDeclaringType().getAnAncestor() instanceof TypeDirContext and
  m.hasName("search") and
  index in [0 .. 1]
}

/**
 * UnboundID sink for LDAP injection vulnerabilities,
 * i.e. LDAPConnection.search, LDAPConnection.asyncSearch or LDAPConnection.searchForEntry method.
 */
predicate unboundIdLdapInjectionSinkMethod(Method m, int index) {
  exists(Parameter param | m.getParameter(index) = param and not param.isVarargs() |
    m instanceof MethodUnboundIdLDAPConnectionSearch or
    m instanceof MethodUnboundIdLDAPConnectionAsyncSearch or
    m instanceof MethodUnboundIdLDAPConnectionSearchForEntry
  )
}

/**
 * Spring LDAP sink for LDAP injection vulnerabilities,
 * i.e. LdapTemplate.authenticate, LdapTemplate.find* or LdapTemplate.search* method.
 */
predicate springLdapInjectionSinkMethod(Method m, int index) {
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

/** Apache LDAP API sink for LDAP injection vulnerabilities, i.e. LdapConnection.search method. */
predicate apacheLdapInjectionSinkMethod(Method m, int index) {
  exists(Parameter param | m.getParameter(index) = param and not param.isVarargs() |
    m.getDeclaringType().getAnAncestor() instanceof TypeApacheLdapConnection and
    m.hasName("search")
  )
}

/** Holds if parameter at index `index` in method `m` is LDAP injection sink. */
predicate ldapInjectionSinkMethod(Method m, int index) {
  jndiLdapInjectionSinkMethod(m, index) or
  unboundIdLdapInjectionSinkMethod(m, index) or
  springLdapInjectionSinkMethod(m, index) or
  apacheLdapInjectionSinkMethod(m, index)
}

/** A data flow sink for unvalidated user input that is used to construct LDAP queries. */
class LdapInjectionSink extends DataFlow::ExprNode {
  LdapInjectionSink() {
    exists(MethodAccess ma, Method m, int index |
      ma.getMethod() = m and
      ma.getArgument(index) = this.getExpr() and
      ldapInjectionSinkMethod(m, index)
    )
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
  exists(MethodAccess ma |
    n1.asExpr() = ma.getAnArgument() and
    (n2.asExpr() = ma or n2.asExpr() = ma.getQualifier())
  |
    ma.getMethod() instanceof MethodLdapNameAddAll
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
    n2.asExpr() = ma and
    ma.getMethod() = m
  |
    m instanceof MethodLdapNameClone or
    m instanceof MethodLdapNameGetAll or
    m instanceof MethodLdapNameGetRdns or
    m instanceof MethodLdapNameToString
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and UnboundID `Filter`,
 * i.e. `Filter.create*(tainted)`.
 */
predicate filterStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getAnArgument() and
    n2.asExpr() = ma and
    ma.getMethod() = m
  |
    m instanceof MethodUnboundIdFilterCreate or
    m instanceof MethodUnboundIdFilterCreateANDFilter or
    m instanceof MethodUnboundIdFilterCreateNOTFilter or
    m instanceof MethodUnboundIdFilterCreateORFilter or
    m instanceof MethodUnboundIdFilterSimplifyFilter
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
  exists(ConstructorCall cc, int index, Parameter param |
    cc.getConstructedType() instanceof TypeUnboundIdSearchRequest
  |
    n1.asExpr() = cc.getArgument(index) and
    n2.asExpr() = cc and
    cc.getConstructor().getParameter(index) = param and
    not param.isVarargs()
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between UnboundID `SearchRequest`
 * and UnboundID `SearchRequest`, i.e. `taintedSearchRequest.duplicate()`.
 */
predicate unboundIdSearchRequestDuplicateStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m | n1.asExpr() = ma.getQualifier() and n2.asExpr() = ma |
    ma.getMethod() = m and
    m.getDeclaringType().getAnAncestor() instanceof TypeUnboundIdReadOnlySearchRequest and
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
    n2.asExpr() = ma.getQualifier() and
    ma.getMethod() = m
  |
    m instanceof MethodUnboundIdSearchRequestSetBaseDN or
    m instanceof MethodUnboundIdSearchRequestSetFilter
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and Spring `LdapQuery`,
 * i.e. `LdapQueryBuilder.query().filter(tainted)` or `LdapQueryBuilder.query().base(tainted)`.
 */
predicate ldapQueryStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m, int index |
    n1.asExpr() = ma.getArgument(index) and
    n2.asExpr() = ma and
    ma.getMethod() = m and
    index = 0
  |
    m instanceof MethodSpringLdapQueryBuilderFilter or
    m instanceof MethodSpringLdapQueryBuilderBase
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between Spring `LdapQueryBuilder` and
 * `Name`, i.e. `taintedLdapQueryBuilder.base()`.
 */
predicate ldapQueryBaseStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma and
    ma.getMethod() = m
  |
    m instanceof MethodSpringLdapQueryBuilderBase and
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
    n2.asExpr() = ma and
    ma.getMethod() = m
  |
    (
      m.getDeclaringType() instanceof TypeSpringLdapQueryBuilder or
      m.getDeclaringType() instanceof TypeSpringConditionCriteria or
      m.getDeclaringType() instanceof TypeSpringContainerCriteria
    ) and
    (
      m.getReturnType() instanceof TypeSpringLdapQueryBuilder or
      m.getReturnType() instanceof TypeSpringConditionCriteria or
      m.getReturnType() instanceof TypeSpringContainerCriteria
    )
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and Spring
 * `HardcodedFilter`, i.e. `new HardcodedFilter(tainted)`.
 */
predicate hardcodedFilterStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeSpringHardcodedFilter |
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
    (n2.asExpr() = ma or n2.asExpr() = ma.getAnArgument()) and
    ma.getMethod() = m
  |
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
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getAnArgument() and
    (n2.asExpr() = ma or n2.asExpr() = ma.getQualifier()) and
    ma.getMethod() = m and
    m.getNumberOfParameters() = 1
  |
    m instanceof MethodSpringLdapNameBuilderNewInstance or
    m instanceof MethodSpringLdapNameBuilderAdd
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between tainted Spring `LdapNameBuilder`
 * and `LdapName`, `LdapNameBuilder.build()`.
 */
predicate ldapNameBuilderBuildStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma | n1.asExpr() = ma.getQualifier() and n2.asExpr() = ma |
    ma.getMethod() instanceof MethodSpringLdapNameBuilderBuild
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `LdapName` via
 * Spring `LdapUtils.newLdapName`, i.e. `LdapUtils.newLdapName(tainted)`.
 */
predicate ldapUtilsStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma | n1.asExpr() = ma.getAnArgument() and n2.asExpr() = ma |
    ma.getMethod() instanceof MethodSpringLdapUtilsNewLdapName
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
  exists(MethodAccess ma, Method m | n1.asExpr() = ma.getQualifier() and n2.asExpr() = ma |
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
  exists(MethodAccess ma, Method m | n1.asExpr() = ma.getQualifier() and n2.asExpr() = ma |
    ma.getMethod() = m and
    m.getDeclaringType().getAnAncestor() instanceof TypeApacheDn and
    (m.hasName("getName") or m.hasName("getNormName") or m.hasName("toString"))
  )
}
