/**
 * Provides classes for working with concepts relating to the Macaron web framework
 */

import go

private module Macaron {
  private class Context extends HTTP::ResponseWriter::Range {
    Context() {
      exists(Method m | m.hasQualifiedName("gopkg.in/macaron.v1", "Context", "Redirect") |
        m = this.getType().getMethod("Redirect")
      )
    }
  }

  private class RedirectCall extends HTTP::Redirect::Range, DataFlow::MethodCallNode {
    RedirectCall() {
      this.getTarget().hasQualifiedName("gopkg.in/macaron.v1", "Context", "Redirect")
    }

    override DataFlow::Node getUrl() { result = this.getArgument(0) }

    override HTTP::ResponseWriter getResponseWriter() { result.getARead() = this.getReceiver() }
  }
}
