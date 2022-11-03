/**
 * Provides classes and predicates for working with the Hibernate framework.
 */

import java
import semmle.code.java.dataflow.ExternalFlow

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

private class SqlSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;spec;kind"
        "org.hibernate;QueryProducer;true;createQuery;;;Argument[0];sql",
        "org.hibernate;QueryProducer;true;createNativeQuery;;;Argument[0];sql",
        "org.hibernate;QueryProducer;true;createSQLQuery;;;Argument[0];sql",
        "org.hibernate;SharedSessionContract;true;createQuery;;;Argument[0];sql",
        "org.hibernate;SharedSessionContract;true;createSQLQuery;;;Argument[0];sql",
        "org.hibernate;Session;true;createQuery;;;Argument[0];sql",
        "org.hibernate;Session;true;createSQLQuery;;;Argument[0];sql"
      ]
  }
}
