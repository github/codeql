/**
 * Provides classes and predicates for working with the Spring LDAP API.
 */

import java
import semmle.code.java.Type
import semmle.code.java.Member

/*--- Types ---*/
/** The class `org.springframework.ldap.core.LdapTemplate`. */
class TypeSpringLdapTemplate extends Class {
  TypeSpringLdapTemplate() {
    this.hasQualifiedName("org.springframework.ldap.core", "LdapTemplate")
  }
}

/** The class `org.springframework.ldap.query.LdapQueryBuilder`. */
class TypeSpringLdapQueryBuilder extends Class {
  TypeSpringLdapQueryBuilder() {
    this.hasQualifiedName("org.springframework.ldap.query", "LdapQueryBuilder")
  }
}

/** The interface `org.springframework.ldap.query.ConditionCriteria`. */
class TypeSpringConditionCriteria extends Interface {
  TypeSpringConditionCriteria() {
    this.hasQualifiedName("org.springframework.ldap.query", "ConditionCriteria")
  }
}

/** The interface `org.springframework.ldap.query.ContainerCriteria`. */
class TypeSpringContainerCriteria extends Interface {
  TypeSpringContainerCriteria() {
    this.hasQualifiedName("org.springframework.ldap.query", "ContainerCriteria")
  }
}

/** The class `org.springframework.ldap.filter.HardcodedFilter`. */
class TypeSpringHardcodedFilter extends Class {
  TypeSpringHardcodedFilter() {
    this.hasQualifiedName("org.springframework.ldap.filter", "HardcodedFilter")
  }
}

/** The interface `org.springframework.ldap.filter.Filter`. */
class TypeSpringLdapFilter extends Interface {
  TypeSpringLdapFilter() { this.hasQualifiedName("org.springframework.ldap.filter", "Filter") }
}

/** The class `org.springframework.ldap.support.LdapNameBuilder`. */
class TypeSpringLdapNameBuilder extends Class {
  TypeSpringLdapNameBuilder() {
    this.hasQualifiedName("org.springframework.ldap.support", "LdapNameBuilder")
  }
}

/** The class `org.springframework.ldap.support.LdapUtils`. */
class TypeSpringLdapUtils extends Class {
  TypeSpringLdapUtils() { this.hasQualifiedName("org.springframework.ldap.support", "LdapUtils") }
}

/*--- Methods ---*/
/**
 * A method with the name `authenticate` declared in
 * `org.springframework.ldap.core.LdapTemplate`.
 */
class MethodSpringLdapTemplateAuthenticate extends Method {
  MethodSpringLdapTemplateAuthenticate() {
    getDeclaringType() instanceof TypeSpringLdapTemplate and
    hasName("authenticate")
  }
}

/**
 * A method with the name `find` declared in
 * `org.springframework.ldap.core.LdapTemplate`.
 */
class MethodSpringLdapTemplateFind extends Method {
  MethodSpringLdapTemplateFind() {
    getDeclaringType() instanceof TypeSpringLdapTemplate and
    hasName("find")
  }
}

/**
 * A method with the name `findOne` declared in
 * `org.springframework.ldap.core.LdapTemplate`.
 */
class MethodSpringLdapTemplateFindOne extends Method {
  MethodSpringLdapTemplateFindOne() {
    getDeclaringType() instanceof TypeSpringLdapTemplate and
    hasName("findOne")
  }
}

/**
 * A method with the name `search` declared in
 * `org.springframework.ldap.core.LdapTemplate`.
 */
class MethodSpringLdapTemplateSearch extends Method {
  MethodSpringLdapTemplateSearch() {
    getDeclaringType() instanceof TypeSpringLdapTemplate and
    hasName("search")
  }
}

/**
 * A method with the name `searchForContext` declared in
 * `org.springframework.ldap.core.LdapTemplate`.
 */
class MethodSpringLdapTemplateSearchForContext extends Method {
  MethodSpringLdapTemplateSearchForContext() {
    getDeclaringType() instanceof TypeSpringLdapTemplate and
    hasName("searchForContext")
  }
}

/**
 * A method with the name `searchForObject` declared in
 * `org.springframework.ldap.core.LdapTemplate`.
 */
class MethodSpringLdapTemplateSearchForObject extends Method {
  MethodSpringLdapTemplateSearchForObject() {
    getDeclaringType() instanceof TypeSpringLdapTemplate and
    hasName("searchForObject")
  }
}

/**
 * A method with the name `filter` declared in
 * `org.springframework.ldap.query.LdapQueryBuilder`.
 */
class MethodSpringLdapQueryBuilderFilter extends Method {
  MethodSpringLdapQueryBuilderFilter() {
    getDeclaringType() instanceof TypeSpringLdapQueryBuilder and
    hasName("filter")
  }
}

/**
 * A method with the name `base` declared in
 * `org.springframework.ldap.query.LdapQueryBuilder`.
 */
class MethodSpringLdapQueryBuilderBase extends Method {
  MethodSpringLdapQueryBuilderBase() {
    getDeclaringType() instanceof TypeSpringLdapQueryBuilder and
    hasName("base")
  }
}

/**
 * A method with the name `newInstance` declared in
 * `org.springframework.ldap.support.LdapNameBuilder`.
 */
class MethodSpringLdapNameBuilderNewInstance extends Method {
  MethodSpringLdapNameBuilderNewInstance() {
    getDeclaringType() instanceof TypeSpringLdapNameBuilder and
    hasName("newInstance")
  }
}

/**
 * A method with the name `add` declared in
 * `org.springframework.ldap.support.LdapNameBuilder`.
 */
class MethodSpringLdapNameBuilderAdd extends Method {
  MethodSpringLdapNameBuilderAdd() {
    getDeclaringType() instanceof TypeSpringLdapNameBuilder and
    hasName("add")
  }
}

/**
 * A method with the name `build` declared in
 * `org.springframework.ldap.support.LdapNameBuilder`.
 */
class MethodSpringLdapNameBuilderBuild extends Method {
  MethodSpringLdapNameBuilderBuild() {
    getDeclaringType() instanceof TypeSpringLdapNameBuilder and
    hasName("build")
  }
}

/**
 * A method with the name `newLdapName` declared in
 * `org.springframework.ldap.support.LdapUtils`.
 */
class MethodSpringLdapUtilsNewLdapName extends Method {
  MethodSpringLdapUtilsNewLdapName() {
    getDeclaringType() instanceof TypeSpringLdapUtils and
    hasName("newLdapName")
  }
}
