/** Provides classes and predicates to reason about CSRF vulnerabilities due to use of unprotected HTTP request types. */

import java
private import semmle.code.java.frameworks.spring.SpringController
private import semmle.code.java.frameworks.MyBatis
private import semmle.code.java.frameworks.Jdbc
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dispatch.VirtualDispatch

/** A method that is not protected from CSRF by default. */
abstract class CsrfUnprotectedMethod extends Method { }

/**
 * A Spring request mapping method that is not protected from CSRF by default.
 *
 * https://docs.spring.io/spring-security/reference/features/exploits/csrf.html#csrf-protection-read-only
 */
private class SpringCsrfUnprotectedMethod extends CsrfUnprotectedMethod instanceof SpringRequestMappingMethod
{
  SpringCsrfUnprotectedMethod() {
    this.hasAnnotation("org.springframework.web.bind.annotation", "GetMapping")
    or
    this.hasAnnotation("org.springframework.web.bind.annotation", "RequestMapping") and
    (
      this.getAnAnnotation().getAnEnumConstantArrayValue("method").getName() =
        ["GET", "HEAD", "OPTIONS", "TRACE"]
      or
      // If no request type is specified with `@RequestMapping`, then all request types
      // are possible, so we treat this as unsafe; example: @RequestMapping(value = "test").
      not exists(this.getAnAnnotation().getAnArrayValue("method"))
    )
  }
}

/** A method that updates a database. */
abstract class DatabaseUpdateMethod extends Method { }

/** A MyBatis Mapper method that updates a database. */
private class MyBatisMapperDatabaseUpdateMethod extends DatabaseUpdateMethod {
  MyBatisMapperDatabaseUpdateMethod() {
    exists(MyBatisMapperSqlOperation mapperXml |
      (
        mapperXml instanceof MyBatisMapperInsert or
        mapperXml instanceof MyBatisMapperUpdate or
        mapperXml instanceof MyBatisMapperDelete
      ) and
      this = mapperXml.getMapperMethod()
    )
  }
}

/** A method declared in `java.sql.PreparedStatement` that updates a database. */
private class PreparedStatementDatabaseUpdateMethod extends DatabaseUpdateMethod {
  PreparedStatementDatabaseUpdateMethod() {
    this instanceof PreparedStatementExecuteUpdateMethod or
    this instanceof PreparedStatementExecuteLargeUpdateMethod
  }
}

/** A method that updates a SQL database. */
private class SqlDatabaseUpdateMethod extends DatabaseUpdateMethod {
  SqlDatabaseUpdateMethod() {
    // TODO: constrain to only insert/update/delete for `execute%` methods; need to track the sql expression into the execute call.
    exists(DataFlow::Node n | this = n.asExpr().(Argument).getCall().getCallee() |
      sinkNode(n, "sql-injection") and
      // do not include `executeQuery` since it is typically used with a select statement
      this.hasName([
          "delete", "insert", "update", "batchUpdate", "executeUpdate", "executeLargeUpdate",
          "execute"
        ])
    )
  }
}

module CallGraph {
  newtype TPathNode =
    TMethod(Method m) or
    TCall(Call c)

  class PathNode extends TPathNode {
    Method asMethod() { this = TMethod(result) }

    Call asCall() { this = TCall(result) }

    string toString() {
      result = this.asMethod().toString()
      or
      result = this.asCall().toString()
    }

    private PathNode getACallee() {
      [viableCallable(this.asCall()), this.asCall().getCallee()] = result.asMethod()
    }

    PathNode getASuccessor() {
      this.asMethod() = result.asCall().getEnclosingCallable()
      or
      result = this.getACallee() and
      (
        exists(PathNode p |
          p = this.getACallee() and
          p.asMethod() instanceof DatabaseUpdateMethod
        )
        implies
        result.asMethod() instanceof DatabaseUpdateMethod
      )
    }

    Location getLocation() {
      result = this.asMethod().getLocation()
      or
      result = this.asCall().getLocation()
    }
  }

  predicate edges(PathNode pred, PathNode succ) { pred.getASuccessor() = succ }
}

import CallGraph

/** Holds if `src` is an unprotected request handler that reaches a state-changing `sink`. */
predicate unprotectedStateChange(PathNode src, PathNode sink, PathNode sinkPred) {
  src.asMethod() instanceof CsrfUnprotectedMethod and
  sink.asMethod() instanceof DatabaseUpdateMethod and
  sinkPred.getASuccessor() = sink and
  src.getASuccessor+() = sinkPred
}
