/**
 * Provides classes and predicates for working with the jOOQ framework.
 */

import java

/**
 * Methods annotated with this allow for generation of "plain SQL"
 * and is prone to SQL injection.
 * https://www.jooq.org/doc/current/manual/sql-building/plain-sql/
 */
private class PlainSQLType extends Annotation {
  PlainSQLType() { this.getType().hasQualifiedName("org.jooq", "PlainSQL") }
}

/**
 * Holds if `m` is a jOOQ SQL method taking an SQL string as its
 * first argument.
 */
predicate jOOQSqlMethod(Method m) {
  m.getAnAnnotation() instanceof PlainSQLType and
  m.getParameterType(0) instanceof TypeString
}
