/**
 * Provides classes and predicates for working with [knex](https://knexjs.org).
 */

private import javascript

/**
 * Provides classes and predicates for working with [knex](https://knexjs.org).
 */
module Knex {
  /** Gets an API node referring to the `knex` library. */
  API::Node knexLibrary() { result = API::moduleImport("knex") }

  /** Gets a method name on Knex objects which return a Knex object. */
  bindingset[result]
  private string chainableKnexMethod() {
    not result in [
        "toString", "valueOf", "then", "catch", "finally", "toSQL", "asCallback", "stream"
      ]
  }

  /** Gets an API node referring to a `knex` object, such as `knex.from('foo')`. */
  API::Node knexObject() {
    result = knexLibrary().getReturn()
    or
    result = knexObject().getReturn()
    or
    result = knexObject().getMember("schema")
    or
    result = knexObject().getMember(chainableKnexMethod()).getReturn()
    or
    // callback for building inner queries, such as `knex.join(function() { this.on('blah') })`
    result = knexObject().getMember(chainableKnexMethod()).getParameter(0).getReceiver()
    or
    // knex.transaction(trx => { ... })
    result = knexObject().getMember("transaction").getParameter(0).getParameter(0)
  }

  /** A call to a Knex method that takes a raw SQL string as input. */
  class RawKnexCall extends DataFlow::CallNode {
    RawKnexCall() { this = knexObject().getMember(["raw", any(string s) + "Raw"]).getACall() }
  }

  /** A SQL string passed to a raw Knex method. */
  private class RawKnexSqlString extends SQL::SqlString {
    RawKnexSqlString() { this = any(RawKnexCall call).getArgument(0).asExpr() }
  }

  /** A call that triggers a SQL query submission by calling then/stream/asCallback. */
  private class KnexDatabaseCallback extends DatabaseAccess, DataFlow::CallNode {
    string member;

    KnexDatabaseCallback() {
      member = ["then", "stream", "asCallback"] and
      this = knexObject().getMember(member).getACall()
    }

    override DataFlow::Node getAResult() {
      member = "then" and
      result = this.getCallback(0).getParameter(0)
      or
      member = "asCallback" and
      result = this.getCallback(0).getParameter(1)
    }

    override DataFlow::Node getAQueryArgument() { none() }
  }

  private class KnexDatabaseAwait extends DatabaseAccess, DataFlow::ValueNode {
    KnexDatabaseAwait() {
      exists(AwaitExpr enclosingAwait | this = enclosingAwait.flow() |
        enclosingAwait.getOperand() = knexObject().getAUse().asExpr()
      )
    }

    override DataFlow::Node getAResult() { result = this }

    override DataFlow::Node getAQueryArgument() { none() }
  }
}
