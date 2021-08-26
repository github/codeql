/**
 * Provides class and predicates to track external data that
 * may represent malicious SQL queries or parts of queries.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Untrusted
import semmle.python.security.SQL

private StringObject first_part(ControlFlowNode command) {
  command.(BinaryExprNode).getOp() instanceof Add and
  command.(BinaryExprNode).getLeft().refersTo(result)
  or
  exists(CallNode call, SequenceObject seq | call = command |
    call = theStrType().lookupAttribute("join") and
    call.getArg(0).refersTo(seq) and
    seq.getInferredElement(0) = result
  )
  or
  command.(BinaryExprNode).getOp() instanceof Mod and
  command.getNode().(StrConst).getLiteralObject() = result
}

/** Holds if `command` appears to be a SQL command string of which `inject` is a part. */
predicate probable_sql_command(ControlFlowNode command, ControlFlowNode inject) {
  exists(string prefix |
    inject = command.getAChild*() and
    first_part(command).getText().regexpMatch(" *" + prefix + ".*")
  |
    prefix = "CREATE" or prefix = "SELECT"
  )
}

/**
 * A taint kind representing a DB cursor.
 * This will be overridden to provide specific kinds of DB cursor.
 */
abstract class DbCursor extends TaintKind {
  bindingset[this]
  DbCursor() { any() }

  string getExecuteMethodName() { result = "execute" }
}

/**
 * A part of a string that appears to be a SQL command and is thus
 * vulnerable to malicious input.
 */
class SimpleSqlStringInjection extends SqlInjectionSink {
  override string toString() { result = "simple SQL string injection" }

  SimpleSqlStringInjection() { probable_sql_command(_, this) }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}

/**
 * A taint source representing sources of DB connections.
 * This will be overridden to provide specific kinds of DB connection sources.
 */
abstract class DbConnectionSource extends TaintSource { }

/**
 * A taint sink that is vulnerable to malicious SQL queries.
 * The `vuln` in `db.connection.execute(vuln)` and similar.
 */
class DbConnectionExecuteArgument extends SqlInjectionSink {
  override string toString() { result = "db.connection.execute" }

  DbConnectionExecuteArgument() {
    exists(CallNode call, DbCursor cursor, string name |
      cursor.taints(call.getFunction().(AttrNode).getObject(name)) and
      cursor.getExecuteMethodName() = name and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}
