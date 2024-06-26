/** Provides classes to reason about LDAP injection attacks. */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.Jndi
import semmle.code.java.frameworks.UnboundId
import semmle.code.java.frameworks.SpringLdap
import semmle.code.java.frameworks.ApacheLdap
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.security.Sanitizers

/** A data flow sink for unvalidated user input that is used to construct LDAP queries. */
abstract class LdapInjectionSink extends DataFlow::Node { }

/** A sanitizer that prevents LDAP injection attacks. */
abstract class LdapInjectionSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to the `LdapInjectionFlowConfig`.
 */
class LdapInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for the `LdapInjectionFlowConfig` configuration.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/** Default sink for LDAP injection vulnerabilities. */
private class DefaultLdapInjectionSink extends LdapInjectionSink {
  DefaultLdapInjectionSink() { sinkNode(this, "ldap-injection") }
}

/** A sanitizer that clears the taint on (boxed) primitive types. */
private class DefaultLdapSanitizer extends LdapInjectionSanitizer instanceof SimpleTypeSanitizer { }

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `LdapName`,
 * i.e. `new LdapName(tainted)`.
 */
private predicate ldapNameStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeLdapName |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `List<Rdn>` and `LdapName`,
 * i.e. `new LdapName().addAll(tainted)`.
 */
private predicate ldapNameAddAllStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma |
    n1.asExpr() = ma.getAnArgument() and
    (n2.asExpr() = ma or n2.asExpr() = ma.getQualifier())
  |
    ma.getMethod() instanceof MethodLdapNameAddAll
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `LdapName` and `LdapName` or
 * `String`, i.e. `taintedLdapName.getAll()`,
 * `taintedLdapName.getRdns()` or `taintedLdapName.toString()`.
 */
private predicate ldapNameGetCloneStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma, Method m |
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma and
    ma.getMethod() = m
  |
    m instanceof MethodLdapNameGetAll or
    m instanceof MethodLdapNameGetRdns or
    m instanceof MethodLdapNameToString
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and UnboundID `Filter`,
 * i.e. `Filter.create*(tainted)`.
 */
private predicate filterStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma, Method m |
    n1.asExpr() = ma.getAnArgument() and
    n2.asExpr() = ma and
    ma.getMethod() = m
  |
    m instanceof MethodUnboundIdFilterCreate or
    m instanceof MethodUnboundIdFilterCreateAndFilter or
    m instanceof MethodUnboundIdFilterCreateNotFilter or
    m instanceof MethodUnboundIdFilterCreateORFilter or
    m instanceof MethodUnboundIdFilterSimplifyFilter
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between UnboundID `Filter` and `String`,
 * i.e. `taintedFilter.toString()` or `taintedFilter.toString(buffer)`.
 */
private predicate filterToStringStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma, Method m |
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
private predicate unboundIdSearchRequestStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
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
private predicate unboundIdSearchRequestDuplicateStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma, Method m | n1.asExpr() = ma.getQualifier() and n2.asExpr() = ma |
    ma.getMethod() = m and
    m.getDeclaringType().getAnAncestor() instanceof TypeUnboundIdReadOnlySearchRequest and
    m.hasName("duplicate")
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between DN or filter and UnboundID
 * `SearchRequest`, i.e. `searchRequest.setBaseDN(tainted)` or `searchRequest.setFilter(tainted)`.
 */
private predicate unboundIdSearchRequestSetStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma, Method m |
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
private predicate ldapQueryStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma, Method m, int index |
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
private predicate ldapQueryBaseStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma, Method m |
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
private predicate ldapQueryBuilderStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma, Method m |
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
private predicate hardcodedFilterStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
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
private predicate springLdapFilterToStringStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma, Method m |
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
private predicate ldapNameBuilderStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma, Method m |
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
private predicate ldapNameBuilderBuildStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma | n1.asExpr() = ma.getQualifier() and n2.asExpr() = ma |
    ma.getMethod() instanceof MethodSpringLdapNameBuilderBuild
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `LdapName` via
 * Spring `LdapUtils.newLdapName`, i.e. `LdapUtils.newLdapName(tainted)`.
 */
private predicate ldapUtilsStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma | n1.asExpr() = ma.getAnArgument() and n2.asExpr() = ma |
    ma.getMethod() instanceof MethodSpringLdapUtilsNewLdapName
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and Apache LDAP API
 * `SearchRequest`, i.e. `searchRequest.setFilter(tainted)` or `searchRequest.setBase(tainted)`.
 */
private predicate apacheSearchRequestStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma, Method m |
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
private predicate apacheSearchRequestGetStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma, Method m | n1.asExpr() = ma.getQualifier() and n2.asExpr() = ma |
    ma.getMethod() = m and
    m.getDeclaringType().getAnAncestor() instanceof TypeApacheSearchRequest and
    (m.hasName("getFilter") or m.hasName("getBase"))
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and Apache LDAP API
 * `Dn`, i.e. `new Dn(tainted)`.
 */
private predicate apacheLdapDnStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeApacheDn |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between Apache LDAP API `Dn`
 * and `String` i.e. `taintedDn.getName()`, `taintedDn.getNormName()` or `taintedDn.toString()`.
 */
private predicate apacheLdapDnGetStep(DataFlow::ExprNode n1, DataFlow::ExprNode n2) {
  exists(MethodCall ma, Method m | n1.asExpr() = ma.getQualifier() and n2.asExpr() = ma |
    ma.getMethod() = m and
    m.getDeclaringType().getAnAncestor() instanceof TypeApacheDn and
    (m.hasName("getName") or m.hasName("getNormName") or m.hasName("toString"))
  )
}

/** A set of additional taint steps to consider when taint tracking LDAP related data flows. */
private class DefaultLdapInjectionAdditionalTaintStep extends LdapInjectionAdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
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
