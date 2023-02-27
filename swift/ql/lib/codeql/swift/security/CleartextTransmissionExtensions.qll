/**
 * Provides classes and predicates for reasoning about cleartext transmission
 * vulnerabilities.
 */

import swift
import codeql.swift.dataflow.DataFlow

/**
 * An `Expr` that is transmitted over a network.
 */
abstract class Transmitted extends Expr { }

/**
 * An `Expr` that is transmitted with `NWConnection.send`.
 */
class NWConnectionSend extends Transmitted {
  NWConnectionSend() {
    // `content` arg to `NWConnection.send` is a sink
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("NWConnection", "send(content:contentContext:isComplete:completion:)") and
      call.getArgument(0).getExpr() = this
    )
  }
}

/**
 * An `Expr` that is used to form a `URL`. Such expressions are very likely to
 * be transmitted over a network, because that's what URLs are for.
 */
class Url extends Transmitted {
  Url() {
    // `string` arg in `URL.init` is a sink
    // (we assume here that the URL goes on to be used in a network operation)
    exists(CallExpr call |
      call.getStaticTarget()
          .(MethodDecl)
          .hasQualifiedName("URL", ["init(string:)", "init(string:relativeTo:)"]) and
      call.getArgument(0).getExpr() = this
    )
  }
}

/**
 * An `Expr` that transmitted through the Alamofire library.
 */
class AlamofireTransmitted extends Transmitted {
  AlamofireTransmitted() {
    // sinks are the first argument containing the URL, and the `parameters`
    // and `headers` arguments to appropriate methods of `Session`.
    exists(CallExpr call, string fName |
      call.getStaticTarget().(MethodDecl).hasQualifiedName("Session", fName) and
      fName.regexpMatch("(request|streamRequest|download)\\(.*") and
      (
        call.getArgument(0).getExpr() = this or
        call.getArgumentWithLabel(["headers", "parameters"]).getExpr() = this
      )
    )
  }
}
