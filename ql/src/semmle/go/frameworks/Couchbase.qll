/**
 * Provides models of commonly used functions in the official Couchbase Go SDK library.
 */

import go

/**
 * Provides models of commonly used functions in the official Couchbase Go SDK library.
 */
module Couchbase {
  /** Gets a package name for v1 of the official Couchbase Go SDK library. */
  string packagePathV1() { result = modulePath() + ["/", "."] + "v1" }

  /** Gets a package name for v2 of the official Couchbase Go SDK library. */
  string packagePathV2() {
    result = modulePath() or
    result = modulePath() + ["/", "."] + "v2"
  }

  /** Gets a module path for the official Couchbase Go SDK library. */
  private string modulePath() {
    result in [
        "gopkg.in/couchbase/gocb", "github.com/couchbase/gocb", "github.com/couchbaselabs/gocb"
      ]
  }

  /**
   * Models of methods on `gocb/AnalyticsQuery` and `gocb/N1qlQuery` which which support a fluent
   * interface by returning the receiver. They are not inherently relevant to taint.
   */
  private class QueryMethodV1 extends TaintTracking::FunctionModel, Method {
    QueryMethodV1() {
      exists(string queryTypeName, string methodName |
        queryTypeName = "AnalyticsQuery" and
        methodName in [
            "ContextId", "Deferred", "Pretty", "Priority", "RawParam", "ServerSideTimeout"
          ]
        or
        queryTypeName = "N1qlQuery" and
        methodName in [
            "AdHoc", "Consistency", "ConsistentWith", "Custom", "PipelineBatch", "PipelineCap",
            "Profile", "ReadOnly", "ScanCap", "Timeout"
          ]
      |
        this.hasQualifiedName(packagePathV1(), queryTypeName, methodName)
      )
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isReceiver() and outp.isResult()
    }
  }

  private class QueryFromN1qlStatementV1 extends TaintTracking::FunctionModel {
    QueryFromN1qlStatementV1() {
      this.hasQualifiedName(packagePathV1(), ["NewAnalyticsQuery", "NewN1qlQuery"])
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(0) and outp.isResult()
    }
  }
}
