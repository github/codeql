/**
 * Provides classes and predicates for working with the jOOQ framework.
 */

import java
import semmle.code.java.dataflow.ExternalFlow

/**
 * Methods annotated with this allow for generation of "plain SQL"
 * and is prone to SQL injection.
 * https://www.jooq.org/doc/current/manual/sql-building/plain-sql/
 */
private class PlainSqlType extends Annotation {
  PlainSqlType() { this.getType().hasQualifiedName("org.jooq", "PlainSQL") }
}

/**
 * Holds if `m` is a jOOQ SQL method taking an SQL string as its
 * first argument.
 */
predicate jOOQSqlMethod(Method m) {
  m.getAnAnnotation() instanceof PlainSqlType and
  m.getParameterType(0) instanceof TypeString
}

private class SqlSinkCsv extends SinkModelCsv {
  override predicate row(string row) { row = "org.jooq;PlainSQL;false;;;Annotated;Argument[0];sql" }
}
