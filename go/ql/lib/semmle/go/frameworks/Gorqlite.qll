/**
 * Provides classes modeling security-relevant aspects of the `gorqlite` package.
 */

import go

/**
 * Provides classes modeling security-relevant aspects of the `gorqlite` package.
 */
module Gorqlite {
  private string packagePath() {
    result =
      package([
          "github.com/rqlite/gorqlite", "github.com/raindog308/gorqlite",
          "github.com/kanikanema/gorqlite"
        ], "")
  }

  // These are expressed using TaintTracking::FunctionModel because varargs functions don't work with Models-as-Data summaries yet.
  private class QueryResultScan extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    QueryResultScan() {
      // signature: func (qr *QueryResult) Scan(dest ...interface{}) error
      this.hasQualifiedName(packagePath(), "QueryResult", "Scan") and
      inp.isReceiver() and
      outp.isParameter(_)
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
