/**
 * Provides classes and predicates for working with the Hibernate framework.
 */

import java

/** The interface `org.hibernate.Session`. */
class HibernateSession extends RefType {
  HibernateSession() { this.hasQualifiedName("org.hibernate", "Session") }
}

/**
 * Holds if `m` is a method on `HibernateSession`, or a subclass, taking an SQL
 * string as its first argument.
 */
predicate hibernateSqlMethod(Method m) {
  m.getDeclaringType().getASourceSupertype*() instanceof HibernateSession and
  m.getParameterType(0) instanceof TypeString and
  (
    m.hasName("createQuery") or
    m.hasName("createSQLQuery")
  )
}
