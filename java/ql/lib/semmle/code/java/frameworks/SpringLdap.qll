/**
 * Provides classes and predicates for working with the Spring LDAP API.
 */

import java

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

/**
 * The interface `org.springframework.ldap.core.LdapOperations` or
 * `org.springframework.ldap.LdapOperations`
 */
class TypeLdapOperations extends Interface {
  TypeLdapOperations() {
    this.hasQualifiedName(["org.springframework.ldap.core", "org.springframework.ldap"],
      "LdapOperations")
  }
}

/*--- Methods ---*/
/**
 * A method with the name `authenticate` declared in
 * `org.springframework.ldap.core.LdapTemplate`.
 */
class MethodSpringLdapTemplateAuthenticate extends Method {
  MethodSpringLdapTemplateAuthenticate() {
    this.getDeclaringType() instanceof TypeSpringLdapTemplate and
    this.hasName("authenticate")
  }
}

/**
 * A method with the name `find` declared in
 * `org.springframework.ldap.core.LdapTemplate`.
 */
class MethodSpringLdapTemplateFind extends Method {
  MethodSpringLdapTemplateFind() {
    this.getDeclaringType() instanceof TypeSpringLdapTemplate and
    this.hasName("find")
  }
}

/**
 * A method with the name `findOne` declared in
 * `org.springframework.ldap.core.LdapTemplate`.
 */
class MethodSpringLdapTemplateFindOne extends Method {
  MethodSpringLdapTemplateFindOne() {
    this.getDeclaringType() instanceof TypeSpringLdapTemplate and
    this.hasName("findOne")
  }
}

/**
 * A method with the name `search` declared in
 * `org.springframework.ldap.core.LdapTemplate`.
 */
class MethodSpringLdapTemplateSearch extends Method {
  MethodSpringLdapTemplateSearch() {
    this.getDeclaringType() instanceof TypeSpringLdapTemplate and
    this.hasName("search")
  }
}

/**
 * A method with the name `searchForContext` declared in
 * `org.springframework.ldap.core.LdapTemplate`.
 */
class MethodSpringLdapTemplateSearchForContext extends Method {
  MethodSpringLdapTemplateSearchForContext() {
    this.getDeclaringType() instanceof TypeSpringLdapTemplate and
    this.hasName("searchForContext")
  }
}

/**
 * A method with the name `searchForObject` declared in
 * `org.springframework.ldap.core.LdapTemplate`.
 */
class MethodSpringLdapTemplateSearchForObject extends Method {
  MethodSpringLdapTemplateSearchForObject() {
    this.getDeclaringType() instanceof TypeSpringLdapTemplate and
    this.hasName("searchForObject")
  }
}

/**
 * A method with the name `filter` declared in
 * `org.springframework.ldap.query.LdapQueryBuilder`.
 */
class MethodSpringLdapQueryBuilderFilter extends Method {
  MethodSpringLdapQueryBuilderFilter() {
    this.getDeclaringType() instanceof TypeSpringLdapQueryBuilder and
    this.hasName("filter")
  }
}

/**
 * A method with the name `base` declared in
 * `org.springframework.ldap.query.LdapQueryBuilder`.
 */
class MethodSpringLdapQueryBuilderBase extends Method {
  MethodSpringLdapQueryBuilderBase() {
    this.getDeclaringType() instanceof TypeSpringLdapQueryBuilder and
    this.hasName("base")
  }
}

/**
 * A method with the name `newInstance` declared in
 * `org.springframework.ldap.support.LdapNameBuilder`.
 */
class MethodSpringLdapNameBuilderNewInstance extends Method {
  MethodSpringLdapNameBuilderNewInstance() {
    this.getDeclaringType() instanceof TypeSpringLdapNameBuilder and
    this.hasName("newInstance")
  }
}

/**
 * A method with the name `add` declared in
 * `org.springframework.ldap.support.LdapNameBuilder`.
 */
class MethodSpringLdapNameBuilderAdd extends Method {
  MethodSpringLdapNameBuilderAdd() {
    this.getDeclaringType() instanceof TypeSpringLdapNameBuilder and
    this.hasName("add")
  }
}

/**
 * A method with the name `build` declared in
 * `org.springframework.ldap.support.LdapNameBuilder`.
 */
class MethodSpringLdapNameBuilderBuild extends Method {
  MethodSpringLdapNameBuilderBuild() {
    this.getDeclaringType() instanceof TypeSpringLdapNameBuilder and
    this.hasName("build")
  }
}

/**
 * A method with the name `newLdapName` declared in
 * `org.springframework.ldap.support.LdapUtils`.
 */
class MethodSpringLdapUtilsNewLdapName extends Method {
  MethodSpringLdapUtilsNewLdapName() {
    this.getDeclaringType() instanceof TypeSpringLdapUtils and
    this.hasName("newLdapName")
  }
}
