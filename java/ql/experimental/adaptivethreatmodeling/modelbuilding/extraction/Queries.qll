/*
 * For internal use only.
 *
 * Represents the security queries for which we currently have ML-powered versions.
 */

newtype TQuery =
  TSqlTaintedQuery() or
  TTaintedPathQuery() or
  TRequestForgeryQuery()

abstract class Query extends TQuery {
  abstract string getName();

  string toString() { result = getName() }
}

class SqlTaintedQuery extends Query, TSqlTaintedQuery {
  override string getName() { result = "SqlTainted" }
}

class TaintedPathQuery extends Query, TTaintedPathQuery {
  override string getName() { result = "TaintedPath" }
}

class RequestForgeryQuery extends Query, TRequestForgeryQuery {
  override string getName() { result = "RequestForgery" }
}
