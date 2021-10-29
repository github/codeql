/**
 * Provides classes modeling security-relevant aspects of the `djangorestframework` PyPI package
 * (imported as `rest_framework`)
 *
 * See
 * - https://www.django-rest-framework.org/
 * - https://pypi.org/project/djangorestframework/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper
private import semmle.python.frameworks.Django
private import semmle.python.frameworks.Stdlib

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `djangorestframework` PyPI package
 * (imported as `rest_framework`)
 *
 * See
 * - https://www.django-rest-framework.org/
 * - https://pypi.org/project/djangorestframework/
 */
private module RestFramework {
  // ---------------------------------------------------------------------------
  // rest_framework.views.APIView handling
  // ---------------------------------------------------------------------------
  /**
   * An `API::Node` representing the `rest_framework.views.APIView` class or any subclass
   * that has explicitly been modeled in the CodeQL libraries.
   */
  private class ModeledApiViewClasses extends Django::Views::View::ModeledSubclass {
    ModeledApiViewClasses() {
      this = API::moduleImport("rest_framework").getMember("views").getMember("APIView")
      // TODO: Need to model all known subclasses
    }
  }

  /**
   * A class that has a super-type which is a rest_framework APIView class, therefore also
   * becoming a APIView class.
   */
  class RestFrameworkApiViewClass extends PrivateDjango::DjangoViewClassFromSuperClass {
    RestFrameworkApiViewClass() {
      this.getABase() = any(ModeledApiViewClasses c).getASubclass*().getAUse().asExpr()
    }

    override Function getARequestHandler() {
      result = super.getARequestHandler()
      or
      // TODO: This doesn't handle attribute assignment. Should be OK, but analysis is not as complete as with
      // points-to and `.lookup`, which would handle `post = my_post_handler` inside class def
      result = this.getAMethod() and
      result.getName() in [
          // these method names where found by looking through the APIView
          // implementation in
          // https://github.com/encode/django-rest-framework/blob/master/rest_framework/views.py#L104
          "initial", "http_method_not_allowed", "permission_denied", "throttled",
          "get_authenticate_header", "perform_content_negotiation", "perform_authentication",
          "check_permissions", "check_object_permissions", "check_throttles", "determine_version",
          "initialize_request", "finalize_response", "dispatch", "options"
        ]
    }
  }

  // ---------------------------------------------------------------------------
  // rest_framework.decorators.api_view handling
  // ---------------------------------------------------------------------------
  /**
   * A function that is a request handler since it is decorated with `rest_framework.decorators.api_view`
   */
  class RestFrameworkFunctionBasedView extends PrivateDjango::DjangoRouteHandler::Range {
    RestFrameworkFunctionBasedView() {
      this.getADecorator() =
        API::moduleImport("rest_framework")
            .getMember("decorators")
            .getMember("api_view")
            .getACall()
            .asExpr()
    }
  }

  /**
   * Ensuring that all `RestFrameworkFunctionBasedView` are also marked as a
   * `HTTP::Server::RequestHandler`. We only need this for the ones that doesn't have a
   * known route setup.
   */
  class RestFrameworkFunctionBasedViewWithoutKnownRoute extends HTTP::Server::RequestHandler::Range,
    PrivateDjango::DjangoRouteHandler instanceof RestFrameworkFunctionBasedView {
    RestFrameworkFunctionBasedViewWithoutKnownRoute() {
      not exists(PrivateDjango::DjangoRouteSetup setup | setup.getARequestHandler() = this)
    }

    override Parameter getARoutedParameter() {
      // Since we don't know the URL pattern, we simply mark all parameters as a routed
      // parameter. This should give us more RemoteFlowSources but could also lead to
      // more FPs. If this turns out to be the wrong tradeoff, we can always change our mind.
      result in [this.getArg(_), this.getArgByName(_)] and
      not result = any(int i | i < this.getFirstPossibleRoutedParamIndex() | this.getArg(i))
    }

    override string getFramework() { result = "Django (rest_framework)" }
  }
}
