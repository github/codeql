/**
 * Provides classes and predicates for working with the Hibernate framework.
 */
overlay[local?]
module;

import java

/** The interface `org.hibernate.query.QueryProducer`. */
class HibernateQueryProducer extends RefType {
  HibernateQueryProducer() { this.hasQualifiedName("org.hibernate.query", "QueryProducer") }
}

/** The interface `org.hibernate.SharedSessionContract`. */
class HibernateSharedSessionContract extends RefType {
  HibernateSharedSessionContract() {
    this.hasQualifiedName("org.hibernate", "SharedSessionContract")
  }
}

/** The interface `org.hibernate.Session`. */
class HibernateSession extends RefType {
  HibernateSession() { this.hasQualifiedName("org.hibernate", "Session") }
}
