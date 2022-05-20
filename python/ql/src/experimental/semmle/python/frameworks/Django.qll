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
private import semmle.python.Concepts

private module ExperimentalPrivateDjango {
  private module DjangoMod {
    API::Node http() { result = API::moduleImport("django").getMember("http") }

    module Http {
      API::Node response() { result = http().getMember("response") }

      API::Node request() { result = http().getMember("request") }

      module Request {
        module HttpRequest {
          class DjangoGETParameter extends DataFlow::Node, RemoteFlowSource::Range {
            DjangoGETParameter() { this = request().getMember("GET").getMember("get").getACall() }

            override string getSourceType() { result = "django.http.request.GET.get" }
          }
        }
      }

      module Response {
        module HttpResponse {
          API::Node baseClassRef() {
            result = response().getMember("HttpResponse")
            or
            // Handle `django.http.HttpResponse` alias
            result = http().getMember("HttpResponse")
          }

          /** Gets a reference to the `django.http.response.HttpResponse` class. */
          API::Node classRef() { result = baseClassRef().getASubclass*() }

          /**
           * A source of instances of `django.http.response.HttpResponse`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponse::instance()` to get references to instances of `django.http.response.HttpResponse`.
           */
          abstract class InstanceSource extends HTTP::Server::HttpResponse::Range, DataFlow::Node {
          }

          /** A direct instantiation of `django.http.response.HttpResponse`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() {
              result in [this.getArg(1), this.getArgByName("content_type")]
            }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponse`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponse`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

          /** Gets a reference to a header instance. */
          private DataFlow::LocalSourceNode headerInstance(DataFlow::TypeTracker t) {
            t.start() and
            (
              exists(SubscriptNode subscript |
                subscript.getObject() = baseClassRef().getReturn().getAUse().asCfgNode() and
                result.asCfgNode() = subscript
              )
              or
              result.(DataFlow::AttrRead).getObject() = baseClassRef().getReturn().getAUse()
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
          class DjangoResponseSetCookieCall extends DataFlow::MethodCallNode, Cookie::Range {
            DjangoResponseSetCookieCall() {
              this.calls(PrivateDjango::DjangoImpl::Http::Response::HttpResponse::instance(),
                "set_cookie")
            }

            override DataFlow::Node getNameArg() {
              result in [this.getArg(0), this.getArgByName("key")]
            }

            override DataFlow::Node getValueArg() {
              result in [this.getArg(1), this.getArgByName("value")]
            }

            override predicate isSecure() {
              DataFlow::exprNode(any(True t))
                  .(DataFlow::LocalSourceNode)
                  .flowsTo(this.(DataFlow::CallCfgNode).getArgByName("secure"))
            }

            override predicate isHttpOnly() {
              DataFlow::exprNode(any(True t))
                  .(DataFlow::LocalSourceNode)
                  .flowsTo(this.(DataFlow::CallCfgNode).getArgByName("httponly"))
            }

            override predicate isSameSite() {
              exists(StrConst str |
                str.getText() in ["Strict", "Lax"] and
                DataFlow::exprNode(str)
                    .(DataFlow::LocalSourceNode)
                    .flowsTo(this.(DataFlow::CallCfgNode).getArgByName("samesite"))
              )
            }

            override DataFlow::Node getHeaderArg() { none() }
          }
        }
      }
    }
  }
}
