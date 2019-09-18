/**
 * Provides classes and predicates for working with the MyBatis framework.
 */

import java

/** The class `org.apache.ibatis.jdbc.SqlRunner`. */
class MyBatisSqlRunner extends RefType {
  MyBatisSqlRunner() { this.hasQualifiedName("org.apache.ibatis.jdbc", "SqlRunner") }
}

/**
 * Holds if `m` is a method on `MyBatisSqlRunner` taking an SQL string as its
 * first argument.
 */
predicate mybatisSqlMethod(Method m) {
  m.getDeclaringType() instanceof MyBatisSqlRunner and
  m.getParameterType(0) instanceof TypeString and
  (
    m.hasName("delete") or
    m.hasName("insert") or
    m.hasName("run") or
    m.hasName("selectAll") or
    m.hasName("selectOne") or
    m.hasName("update")
  )
}
