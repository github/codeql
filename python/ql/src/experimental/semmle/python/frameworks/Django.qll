/**
 * Provides classes modeling security-relevant aspects of the `django` PyPI package.
 * See https://www.djangoproject.com/.
 */

private import python
private import semmle.python.frameworks.Django
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

private module PrivateDjango {
  API::Node django() { result = API::moduleImport("django") }

  private module django {
    API::Node http() { result = django().getMember("http") }

    module http {
      API::Node response() { result = http().getMember("response") }

      module response {
        module HttpResponse {
          API::Node baseClassRef() {
            result = response().getMember("HttpResponse").getReturn()
            or
            // Handle `django.http.HttpResponse` alias
            result = http().getMember("HttpResponse").getReturn()
          }

          /** Gets a reference to a header instance. */
          private DataFlow::LocalSourceNode headerInstance(DataFlow::TypeTracker t) {
            t.start() and
            (
              exists(SubscriptNode subscript |
                subscript.getObject() = baseClassRef().getAUse().asCfgNode() and
                result.asCfgNode() = subscript
              )
              or
              result.(DataFlow::AttrRead).getObject() = baseClassRef().getAUse()
            )
            or
            exists(DataFlow::TypeTracker t2 | result = headerInstance(t2).track(t2, t))
          }

          /** Gets a reference to a header instance use. */
          private DataFlow::Node headerInstance() {
            headerInstance(DataFlow::TypeTracker::end()).flowsTo(result)
          }

          /** Gets a reference to a header instance call with `__setitem__`. */
          private DataFlow::Node headerSetItemCall() {
            result = headerInstance() and
            result.(DataFlow::AttrRead).getAttributeName() = "__setitem__"
          }

          class DjangoResponseSetItemCall extends DataFlow::CallCfgNode, HeaderDeclaration::Range {
            DjangoResponseSetItemCall() { this.getFunction() = headerSetItemCall() }

            override DataFlow::Node getAnInput() { result = this.getArg([0, 1]) }
          }

          class DjangoResponseDefinition extends DataFlow::Node, HeaderDeclaration::Range {
            DataFlow::Node headerInput;

            DjangoResponseDefinition() {
              this.asCfgNode().(DefinitionNode) = headerInstance().asCfgNode() and
              headerInput.asCfgNode() = this.asCfgNode().(DefinitionNode).getValue()
            }

            override DataFlow::Node getAnInput() {
              result.asExpr() in [headerInput.asExpr(), this.asExpr().(Subscript).getIndex()]
            }
          }
        }
      }
    }
  }
}
