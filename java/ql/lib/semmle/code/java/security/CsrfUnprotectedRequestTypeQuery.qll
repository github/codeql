/** Provides classes and predicates to reason about CSRF vulnerabilities due to use of unprotected HTTP request types. */

import java
private import semmle.code.java.frameworks.spring.SpringController
private import semmle.code.java.frameworks.stapler.Stapler
private import semmle.code.java.frameworks.MyBatis
private import semmle.code.java.frameworks.Jdbc
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dispatch.VirtualDispatch
private import semmle.code.java.dataflow.TaintTracking

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

/**
 * A Stapler web method that is not protected from CSRF by default.
 *
 * https://www.jenkins.io/doc/developer/security/form-validation/#protecting-from-csrf
 */
private class StaplerCsrfUnprotectedMethod extends CsrfUnprotectedMethod instanceof StaplerWebMethod
{
  StaplerCsrfUnprotectedMethod() {
    not (
      this.hasAnnotation("org.kohsuke.stapler.interceptor", "RequirePOST") or
      this.hasAnnotation("org.kohsuke.stapler.verb", "POST")
    )
  }
}

/** A method that appears to change application state based on its name. */
private class NameStateChangeMethod extends Method {
  NameStateChangeMethod() {
    this.getName()
        .regexpMatch("(^|\\w+(?=[A-Z]))((?i)post|put|patch|delete|remove|create|add|update|edit|(un|)publish|fill|move|transfer|log(out|in)|access|connect(|ion)|register|submit)($|(?![a-z])\\w+)") and
    not this.getName().regexpMatch("^(get|show|view|list|query|find)(?![a-z])\\w*")
  }
}

/** A method that updates a database. */
abstract class DatabaseUpdateMethod extends Method { }

/** A MyBatis method that updates a database. */
private class MyBatisDatabaseUpdateMethod extends DatabaseUpdateMethod {
  MyBatisDatabaseUpdateMethod() {
    exists(MyBatisMapperSqlOperation mapperXml |
      (
        mapperXml instanceof MyBatisMapperInsert or
        mapperXml instanceof MyBatisMapperUpdate or
        mapperXml instanceof MyBatisMapperDelete
      ) and
      this = mapperXml.getMapperMethod()
    )
    or
    exists(MyBatisSqlOperationAnnotationMethod m | this = m |
      not m.getAnAnnotation().getType().hasQualifiedName("org.apache.ibatis.annotations", "Select")
    )
    or
    exists(Method m | this = m |
      m.hasAnnotation("org.apache.ibatis.annotations", ["Delete", "Update", "Insert"] + "Provider")
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

/** A method found via the sql-injection models which may update a SQL database. */
private class SqlInjectionMethod extends DatabaseUpdateMethod {
  SqlInjectionMethod() {
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

/**
 * A taint-tracking configuration for reasoning about SQL queries that update a database.
 */
module SqlExecuteConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(StringLiteral sl | source.asExpr() = sl |
      sl.getValue().regexpMatch("^(?i)(insert|update|delete).*")
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Method m | m = sink.asExpr().(Argument).getCall().getCallee() |
      m instanceof SqlInjectionMethod and
      m.hasName("execute")
    )
  }
}

/** Tracks flow from SQL queries that update a database to the argument of an execute method call. */
module SqlExecuteFlow = TaintTracking::Global<SqlExecuteConfig>;

module CallGraph {
  newtype TCallPathNode =
    TMethod(Method m) or
    TCall(Call c)

  class CallPathNode extends TCallPathNode {
    Method asMethod() { this = TMethod(result) }

    Call asCall() { this = TCall(result) }

    string toString() {
      result = this.asMethod().toString()
      or
      result = this.asCall().toString()
    }

    private CallPathNode getACallee() {
      [viableCallable(this.asCall()), this.asCall().getCallee()] = result.asMethod()
    }

    CallPathNode getASuccessor() {
      this.asMethod() = result.asCall().getEnclosingCallable()
      or
      result = this.getACallee() and
      (
        exists(CallPathNode p |
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

  predicate edges(CallPathNode pred, CallPathNode succ) { pred.getASuccessor() = succ }
}

import CallGraph

/**
 * Holds if `src` is an unprotected request handler that reaches a
 * `sink` that updates a database.
 */
predicate unprotectedDatabaseUpdate(CallPathNode sourceMethod, CallPathNode sinkMethodCall) {
  sourceMethod.asMethod() instanceof CsrfUnprotectedMethod and
  exists(CallPathNode sinkMethod |
    sinkMethod.asMethod() instanceof DatabaseUpdateMethod and
    sinkMethodCall.getASuccessor() = sinkMethod and
    sourceMethod.getASuccessor+() = sinkMethodCall and
    if
      sinkMethod.asMethod() instanceof SqlInjectionMethod and
      sinkMethod.asMethod().hasName("execute")
    then
      exists(SqlExecuteFlow::PathNode executeSrc, SqlExecuteFlow::PathNode executeSink |
        SqlExecuteFlow::flowPath(executeSrc, executeSink)
      |
        sinkMethodCall.asCall() = executeSink.getNode().asExpr().(Argument).getCall()
      )
    else any()
  )
}

/**
 * Holds if `src` is an unprotected request handler that appears to
 * change application state based on its name.
 */
private predicate unprotectedHeuristicStateChange(CallPathNode sourceMethod, CallPathNode sinkMethod) {
  sourceMethod.asMethod() instanceof CsrfUnprotectedMethod and
  sinkMethod.asMethod() instanceof NameStateChangeMethod and
  sinkMethod = sourceMethod and
  // exclude any alerts that update a database
  not unprotectedDatabaseUpdate(sourceMethod, _)
}

/**
 * Holds if `src` is an unprotected request handler that may
 * change an application's state.
 */
predicate unprotectedStateChange(CallPathNode source, CallPathNode sink) {
  unprotectedDatabaseUpdate(source, sink) or
  unprotectedHeuristicStateChange(source, sink)
}
