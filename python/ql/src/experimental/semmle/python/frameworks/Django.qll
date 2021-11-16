/**
 * Provides classes modeling security-relevant aspects of the `django` PyPI package.
 * See https://www.djangoproject.com/.
 */

private import python
private import semmle.python.frameworks.Django
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs
import semmle.python.dataflow.new.RemoteFlowSources

private module PrivateDjango {
  private module django {
    API::Node http() { result = API::moduleImport("django").getMember("http") }

    module http {
      API::Node response() { result = http().getMember("response") }

      API::Node request() { result = http().getMember("request") }

      module request {
        module HttpRequest {
          class DjangoGETParameter extends DataFlow::Node, RemoteFlowSource::Range {
            DjangoGETParameter() { this = request().getMember("GET").getMember("get").getACall() }

            override string getSourceType() { result = "django.http.request.GET.get" }
          }
        }
      }

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

            override DataFlow::Node getNameArg() { result = this.getArg(0) }

            override DataFlow::Node getValueArg() { result = this.getArg(1) }
          }

          class DjangoResponseDefinition extends DataFlow::Node, HeaderDeclaration::Range {
            DataFlow::Node headerInput;

            DjangoResponseDefinition() {
              this.asCfgNode().(DefinitionNode) = headerInstance().asCfgNode() and
              headerInput.asCfgNode() = this.asCfgNode().(DefinitionNode).getValue()
            }

            override DataFlow::Node getNameArg() {
              result.asExpr() = this.asExpr().(Subscript).getIndex()
            }

            override DataFlow::Node getValueArg() { result = headerInput }
          }

          /**
           * Gets a call to `set_cookie()`.
           *
           * Given the following example:
           *
           * ```py
           * def django_response(request):
           *    resp = django.http.HttpResponse()
           *    resp.set_cookie("name", "value", secure=True, httponly=True, samesite='Lax')
           *    return resp
           * ```
           *
           * * `this` would be `resp.set_cookie("name", "value", secure=False, httponly=False, samesite='None')`.
           * * `getName()`'s result would be `"name"`.
           * * `getValue()`'s result would be `"value"`.
           * * `isSecure()` predicate would succeed.
           * * `isHttpOnly()` predicate would succeed.
           * * `isSameSite()` predicate would succeed.
           */
          class DjangoSetCookieCall extends DataFlow::CallCfgNode, Cookie::Range {
            DjangoSetCookieCall() { this = baseClassRef().getMember("set_cookie").getACall() }

            override DataFlow::Node getNameArg() { result = this.getArg(0) }

            override DataFlow::Node getValueArg() { result = this.getArgByName("value") }

            override predicate isSecure() {
              DataFlow::exprNode(any(True t))
                  .(DataFlow::LocalSourceNode)
                  .flowsTo(this.getArgByName("secure"))
            }

            override predicate isHttpOnly() {
              DataFlow::exprNode(any(True t))
                  .(DataFlow::LocalSourceNode)
                  .flowsTo(this.getArgByName("httponly"))
            }

            override predicate isSameSite() {
              this.getArgByName("samesite").asExpr().(Str_).getS() in ["Strict", "Lax"]
            }

            override DataFlow::Node getHeaderArg() { none() }
          }
        }
      }
    }
  }
}
