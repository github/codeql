/**
 * Provides classes for working with HTTP-related concepts such as requests and responses.
 */

import go

module ThirdPartHttpLib {
  /**
   * Source from go-resultful
   * Document: https://github.com/emicklei/go-restful
   */
  class GoRestfulSource extends DataFlow::Node, UntrustedFlowSource::Range {
    GoRestfulSource() {
      exists(
	Method meth, string name |
	meth.hasQualifiedName("github.com/emicklei/go-restful", "Request", name) and
	asExpr() = meth.getACall().asExpr() and
	(
	  name = "QueryParameters" or name = "QueryParameter" or
	  name = "BodyParamater" or name = "HeaderParameter" or
	  name = "PathParameter" or name = "PathParameters"
	)
      )
    }
  }
}

