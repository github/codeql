/** Provides classes and predicates to reason about CSRF vulnerabilities due to use of unprotected HTTP request types. */

import java
private import semmle.code.java.frameworks.spring.SpringController
private import semmle.code.java.frameworks.stapler.Stapler
private import semmle.code.java.frameworks.MyBatis
private import semmle.code.java.frameworks.Jdbc
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dispatch.VirtualDispatch
private import semmle.code.java.dataflow.TaintTracking
import CallGraph

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
      this.getMethodValue() = ["GET", "HEAD"]
      or
      // If no request type is specified with `@RequestMapping`, then all request types
      // are possible, so we treat this as unsafe; example: @RequestMapping(value = "test").
      not exists(this.getMethodValue())
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
    not this.hasAnnotation("org.kohsuke.stapler.interceptor", "RequirePOST") and
    // Jenkins only explicitly protects against CSRF for POST requests, but we
    // also exclude PUT and DELETE since these request types are only exploitable
    // if there is a CORS issue.
    not this.hasAnnotation("org.kohsuke.stapler.verb", ["POST", "PUT", "DELETE"])
  }
}

/** Gets a word that is interesting because it may indicate a state change. */
private string getAnInterestingWord() {
  result =
    [
      "post", "put", "patch", "delete", "remove", "create", "add", "update", "edit", "publish",
      "unpublish", "fill", "move", "transfer", "logout", "login", "access", "connect", "connection",
      "register", "submit"
    ]
}

/**
 * Gets the regular expression used for matching strings that look like they
 * contain an interesting word.
 */
private string getInterestingWordRegex() {
  result = "(^|\\w+(?=[A-Z]))((?i)" + concat(getAnInterestingWord(), "|") + ")($|(?![a-z])\\w+)"
}

/** Gets a word that is uninteresting because it likely does not indicate a state change. */
private string getAnUninterestingWord() {
  result = ["get", "show", "view", "list", "query", "find"]
}

/**
 * Gets the regular expression used for matching strings that look like they
 * contain an uninteresting word.
 */
private string getUninterestingWordRegex() {
  result = "^(" + concat(getAnUninterestingWord(), "|") + ")(?![a-z])\\w*"
}

/** A method that appears to change application state based on its name. */
private class NameBasedStateChangeMethod extends Method {
  NameBasedStateChangeMethod() {
    this.getName().regexpMatch(getInterestingWordRegex()) and
    not this.getName().regexpMatch(getUninterestingWordRegex())
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

/** A method found via the sql-injection sink models which may update a database. */
private class SqlInjectionDatabaseUpdateMethod extends DatabaseUpdateMethod {
  SqlInjectionDatabaseUpdateMethod() {
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
 * A taint-tracking configuration for reasoning about SQL statements that update
 * a database via a call to an `execute` method.
 */
private module SqlExecuteConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(StringLiteral sl | source.asExpr() = sl |
      sl.getValue().regexpMatch("^(?i)(insert|update|delete).*")
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Method m | m = sink.asExpr().(Argument).getCall().getCallee() |
      m instanceof SqlInjectionDatabaseUpdateMethod and
      m.hasName("execute")
    )
  }
}

/**
 * Tracks flow from SQL statements that update a database to the argument of
 * an `execute` method call.
 */
private module SqlExecuteFlow = TaintTracking::Global<SqlExecuteConfig>;

/** Provides classes and predicates representing call graph paths. */
module CallGraph {
  private newtype TCallPathNode =
    TMethod(Method m) or
    TCall(Call c)

  /** A node in a call path graph */
  class CallPathNode extends TCallPathNode {
    /** Gets the method corresponding to this `CallPathNode`, if any. */
    Method asMethod() { this = TMethod(result) }

    /** Gets the call corresponding to this `CallPathNode`, if any. */
    Call asCall() { this = TCall(result) }

    /** Gets the string representation of this `CallPathNode`. */
    string toString() {
      result = this.asMethod().toString()
      or
      result = this.asCall().toString()
    }

    private CallPathNode getACallee() {
      [viableCallable(this.asCall()), this.asCall().getCallee()] = result.asMethod()
    }

    pragma[nomagic]
    private predicate canTargetDatabaseUpdateMethod() {
      exists(CallPathNode p |
        p = this.getACallee() and
        p.asMethod() instanceof DatabaseUpdateMethod
      )
    }

    /** Gets a successor node of this `CallPathNode`, if any. */
    CallPathNode getASuccessor() {
      this.asMethod() = result.asCall().getEnclosingCallable()
      or
      result = this.getACallee() and
      (
        this.canTargetDatabaseUpdateMethod()
        implies
        result.asMethod() instanceof DatabaseUpdateMethod
      )
    }

    /** Gets the location of this `CallPathNode`. */
    Location getLocation() {
      result = this.asMethod().getLocation()
      or
      result = this.asCall().getLocation()
    }
  }

  /** Holds if `pred` has a successor node `succ`. */
  predicate edges(CallPathNode pred, CallPathNode succ) { pred.getASuccessor() = succ }
}

/** Holds if `sourceMethod` is an unprotected request handler. */
private predicate source(CallPathNode sourceMethod) {
  sourceMethod.asMethod() instanceof CsrfUnprotectedMethod
}

/** Holds if `sinkMethodCall` updates a database. */
private predicate sink(CallPathNode sinkMethodCall) {
  exists(CallPathNode sinkMethod |
    sinkMethod.asMethod() instanceof DatabaseUpdateMethod and
    sinkMethodCall.getASuccessor() = sinkMethod and
    // exclude SQL `execute` calls that do not update database
    if
      sinkMethod.asMethod() instanceof SqlInjectionDatabaseUpdateMethod and
      sinkMethod.asMethod().hasName("execute")
    then SqlExecuteFlow::flowToExpr(sinkMethodCall.asCall().getAnArgument())
    else any()
  )
}

/**
 * Holds if `sourceMethod` is an unprotected request handler that reaches a
 * `sinkMethodCall` that updates a database.
 */
private predicate unprotectedDatabaseUpdate(CallPathNode sourceMethod, CallPathNode sinkMethodCall) =
  doublyBoundedFastTC(CallGraph::edges/2, source/1, sink/1)(sourceMethod, sinkMethodCall)

/**
 * Holds if `sourceMethod` is an unprotected request handler that appears to
 * change application state based on its name.
 */
private predicate unprotectedNameBasedStateChange(CallPathNode sourceMethod, CallPathNode sinkMethod) {
  sourceMethod.asMethod() instanceof CsrfUnprotectedMethod and
  sinkMethod.asMethod() instanceof NameBasedStateChangeMethod and
  sinkMethod = sourceMethod and
  // exclude any alerts that update a database
  not unprotectedDatabaseUpdate(sourceMethod, _)
}

/**
 * Holds if `source` is an unprotected request handler that may
 * change an application's state.
 */
predicate unprotectedStateChange(CallPathNode source, CallPathNode sink) {
  unprotectedDatabaseUpdate(source, sink) or
  unprotectedNameBasedStateChange(source, sink)
}
