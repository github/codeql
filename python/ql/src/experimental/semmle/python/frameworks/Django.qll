/**
 * Provides classes modeling security-relevant aspects of the `django` PyPI package.
 * See https://www.djangoproject.com/.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.semmle.python.Concepts
import semmle.python.regex

/**
 * Provides models for the `django` PyPI package.
 * See https://www.djangoproject.com/.
 */
private module Django {
  // ---------------------------------------------------------------------------
  // django
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `django` module. */
  private DataFlow::Node django(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("django")
    or
    exists(DataFlow::TypeTracker t2 | result = django(t2).track(t2, t))
  }

  /** Gets a reference to the `django` module. */
  DataFlow::Node django() { result = django(DataFlow::TypeTracker::end()) }

  /**
   * Gets a reference to the attribute `attr_name` of the `django` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node django_attr(DataFlow::TypeTracker t, string attr_name) {
    attr_name in ["urls", "http"] and
    (
      t.start() and
      result = DataFlow::importNode("django" + "." + attr_name)
      or
      t.startInAttr(attr_name) and
      result = DataFlow::importNode("django")
    )
    or
    // Due to bad performance when using normal setup with `django_attr(t2, attr_name).track(t2, t)`
    // we have inlined that code and forced a join
    exists(DataFlow::TypeTracker t2 |
      exists(DataFlow::StepSummary summary |
        django_attr_first_join(t2, attr_name, result, summary) and
        t = t2.append(summary)
      )
    )
  }

  pragma[nomagic]
  private predicate django_attr_first_join(
    DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
  ) {
    DataFlow::StepSummary::step(django_attr(t2, attr_name), res, summary)
  }

  /**
   * Gets a reference to the attribute `attr_name` of the `django` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node django_attr(string attr_name) {
    result = django_attr(DataFlow::TypeTracker::end(), attr_name)
  }

  /** Provides models for the `django` module. */
  module django {
    // -------------------------------------------------------------------------
    // django.urls
    // -------------------------------------------------------------------------
    /** Gets a reference to the `django.urls` module. */
    DataFlow::Node urls() { result = django_attr("urls") }

    /** Provides models for the `django.urls` module */
    module urls {
      /**
       * Gets a reference to the attribute `attr_name` of the `urls` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node urls_attr(DataFlow::TypeTracker t, string attr_name) {
        attr_name in ["path", "re_path"] and
        (
          t.start() and
          result = DataFlow::importNode("django.urls" + "." + attr_name)
          or
          t.startInAttr(attr_name) and
          result = DataFlow::importNode("django.urls")
          or
          t.startInAttr(attr_name) and
          result = django::urls()
        )
        or
        // Due to bad performance when using normal setup with `urls_attr(t2, attr_name).track(t2, t)`
        // we have inlined that code and forced a join
        exists(DataFlow::TypeTracker t2 |
          exists(DataFlow::StepSummary summary |
            urls_attr_first_join(t2, attr_name, result, summary) and
            t = t2.append(summary)
          )
        )
      }

      pragma[nomagic]
      private predicate urls_attr_first_join(
        DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
        DataFlow::StepSummary summary
      ) {
        DataFlow::StepSummary::step(urls_attr(t2, attr_name), res, summary)
      }

      /**
       * Gets a reference to the attribute `attr_name` of the `urls` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node urls_attr(string attr_name) {
        result = urls_attr(DataFlow::TypeTracker::end(), attr_name)
      }

      /**
       * Gets a reference to the `django.urls.path` function.
       * See https://docs.djangoproject.com/en/3.0/ref/urls/#path
       */
      DataFlow::Node path() { result = urls_attr("path") }

      /**
       * Gets a reference to the `django.urls.re_path` function.
       * See https://docs.djangoproject.com/en/3.0/ref/urls/#re_path
       */
      DataFlow::Node re_path() { result = urls_attr("re_path") }
    }

    // -------------------------------------------------------------------------
    // django.http
    // -------------------------------------------------------------------------
    /** Gets a reference to the `django.http` module. */
    DataFlow::Node http() { result = django_attr("http") }

    /** Provides models for the `django.http` module */
    module http {
      /**
       * Gets a reference to the attribute `attr_name` of the `django.http` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node http_attr(DataFlow::TypeTracker t, string attr_name) {
        attr_name in ["request", "HttpRequest"] and
        (
          t.start() and
          result = DataFlow::importNode("django.http" + "." + attr_name)
          or
          t.startInAttr(attr_name) and
          result = django::http()
        )
        or
        // Due to bad performance when using normal setup with `http_attr(t2, attr_name).track(t2, t)`
        // we have inlined that code and forced a join
        exists(DataFlow::TypeTracker t2 |
          exists(DataFlow::StepSummary summary |
            http_attr_first_join(t2, attr_name, result, summary) and
            t = t2.append(summary)
          )
        )
      }

      pragma[nomagic]
      private predicate http_attr_first_join(
        DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
        DataFlow::StepSummary summary
      ) {
        DataFlow::StepSummary::step(http_attr(t2, attr_name), res, summary)
      }

      /**
       * Gets a reference to the attribute `attr_name` of the `django.http` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node http_attr(string attr_name) {
        result = http_attr(DataFlow::TypeTracker::end(), attr_name)
      }

      // ---------------------------------------------------------------------------
      // django.http.request
      // ---------------------------------------------------------------------------
      /** Gets a reference to the `django.http.request` module. */
      DataFlow::Node request() { result = http_attr("request") }

      /** Provides models for the `django.http.request` module. */
      module request {
        /**
         * Gets a reference to the attribute `attr_name` of the `django.http.request` module.
         * WARNING: Only holds for a few predefined attributes.
         */
        private DataFlow::Node request_attr(DataFlow::TypeTracker t, string attr_name) {
          attr_name in ["HttpRequest"] and
          (
            t.start() and
            result = DataFlow::importNode("django.http.request" + "." + attr_name)
            or
            t.startInAttr(attr_name) and
            result = django::http::request()
          )
          or
          // Due to bad performance when using normal setup with `request_attr(t2, attr_name).track(t2, t)`
          // we have inlined that code and forced a join
          exists(DataFlow::TypeTracker t2 |
            exists(DataFlow::StepSummary summary |
              request_attr_first_join(t2, attr_name, result, summary) and
              t = t2.append(summary)
            )
          )
        }

        pragma[nomagic]
        private predicate request_attr_first_join(
          DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
          DataFlow::StepSummary summary
        ) {
          DataFlow::StepSummary::step(request_attr(t2, attr_name), res, summary)
        }

        /**
         * Gets a reference to the attribute `attr_name` of the `django.http.request` module.
         * WARNING: Only holds for a few predefined attributes.
         */
        private DataFlow::Node request_attr(string attr_name) {
          result = request_attr(DataFlow::TypeTracker::end(), attr_name)
        }

        /**
         * Provides models for the `django.http.request.HttpRequest` class
         *
         * See https://docs.djangoproject.com/en/3.0/ref/request-response/#httprequest-objects
         */
        module HttpRequest {
          /** Gets a reference to the `django.http.request.HttpRequest` class. */
          private DataFlow::Node classRef(DataFlow::TypeTracker t) {
            t.start() and
            result = request_attr("HttpRequest")
            or
            // handle django.http.HttpRequest alias
            t.start() and
            result = http_attr("HttpRequest")
            or
            exists(DataFlow::TypeTracker t2 | result = classRef(t2).track(t2, t))
          }

          /** Gets a reference to the `django.http.request.HttpRequest` class. */
          DataFlow::Node classRef() { result = classRef(DataFlow::TypeTracker::end()) }

          /**
           * A source of an instance of `django.http.request.HttpRequest`.
           *
           * This can include instantiation of the class, return value from function
           * calls, or a special parameter that will be set when functions are call by external
           * library.
           *
           * Use `django::http::request::HttpRequest::instance()` predicate to get
           * references to instances of `django.http.request.HttpRequest`.
           */
          abstract class InstanceSource extends DataFlow::Node { }

          /** Gets a reference to an instance of `django.http.request.HttpRequest`. */
          private DataFlow::Node instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.request.HttpRequest`. */
          DataFlow::Node instance() { result = instance(DataFlow::TypeTracker::end()) }
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // routing modeling
  // ---------------------------------------------------------------------------
  /**
   * Gets a reference to the Function `func`.
   *
   * The idea is that this function should be used as a route handler when setting up a
   * route, but currently it just tracks all functions, since we can't do type-tracking
   * backwards yet (TODO).
   */
  private DataFlow::Node djangoRouteHandlerFunctionTracker(DataFlow::TypeTracker t, Function func) {
    t.start() and
    result = DataFlow::exprNode(func.getDefinition())
    or
    exists(DataFlow::TypeTracker t2 |
      result = djangoRouteHandlerFunctionTracker(t2, func).track(t2, t)
    )
  }

  /**
   * Gets a reference to the Function `func`.
   *
   * The idea is that this function should be used as a route handler when setting up a
   * route, but currently it just tracks all functions, since we can't do type-tracking
   * backwards yet (TODO).
   */
  private DataFlow::Node djangoRouteHandlerFunctionTracker(Function func) {
    result = djangoRouteHandlerFunctionTracker(DataFlow::TypeTracker::end(), func)
  }

  /**
   * A function that is used as a django route handler.
   */
  private class DjangoRouteHandler extends Function {
    DjangoRouteHandler() { exists(djangoRouteHandlerFunctionTracker(this)) }

    /** Gets the index of the request parameter. */
    int getRequestParamIndex() {
      not this.isMethod() and
      result = 0
      or
      this.isMethod() and
      result = 1
    }

    /** Gets the request parameter. */
    Parameter getRequestParam() { result = this.getArg(this.getRequestParamIndex()) }
  }

  abstract private class DjangoRouteSetup extends HTTP::Server::RouteSetup::Range, DataFlow::CfgNode {
    abstract override DjangoRouteHandler getARouteHandler();
  }

  /**
   * Gets the regex that is used by django to find routed parameters when using `django.urls.path`.
   *
   * Taken from https://github.com/django/django/blob/7d1bf29977bb368d7c28e7c6eb146db3b3009ae7/django/urls/resolvers.py#L199
   */
  private string pathRoutedParameterRegex() {
    result = "<(?:(?<converter>[^>:]+):)?(?<parameter>\\w+)>"
  }

  /**
   * A call to `django.urls.path`.
   *
   * See https://docs.djangoproject.com/en/3.0/ref/urls/#path
   */
  private class DjangoUrlsPathCall extends DjangoRouteSetup {
    override CallNode node;

    DjangoUrlsPathCall() { node.getFunction() = django::urls::path().asCfgNode() }

    override DataFlow::Node getUrlPatternArg() {
      result.asCfgNode() = [node.getArg(0), node.getArgByName("route")]
    }

    override DjangoRouteHandler getARouteHandler() {
      exists(DataFlow::Node viewArg |
        viewArg.asCfgNode() in [node.getArg(1), node.getArgByName("view")] and
        djangoRouteHandlerFunctionTracker(result) = viewArg
      )
    }

    override Parameter getARoutedParameter() {
      // If we don't know the URL pattern, we simply mark all parameters as a routed
      // parameter. This should give us more RemoteFlowSources but could also lead to
      // more FPs. If this turns out to be the wrong tradeoff, we can always change our mind.
      exists(DjangoRouteHandler routeHandler | routeHandler = this.getARouteHandler() |
        not exists(this.getUrlPattern()) and
        result in [routeHandler.getArg(_), routeHandler.getArgByName(_)] and
        not result = any(int i | i <= routeHandler.getRequestParamIndex() | routeHandler.getArg(i))
      )
      or
      exists(string name |
        result = this.getARouteHandler().getArgByName(name) and
        exists(string match |
          match = this.getUrlPattern().regexpFind(pathRoutedParameterRegex(), _, _) and
          name = match.regexpCapture(pathRoutedParameterRegex(), 2)
        )
      )
    }
  }

  /**
   * A regex that is used in a call to `django.urls.re_path`.
   *
   * Needs this subclass to be considered a RegexString.
   */
  private class DjangoUrlsRePathRegex extends RegexString {
    DjangoUrlsRePathCall rePathCall;

    DjangoUrlsRePathRegex() {
      this instanceof StrConst and
      DataFlow::localFlow(DataFlow::exprNode(this), rePathCall.getUrlPatternArg())
    }

    DjangoUrlsRePathCall getRePathCall() { result = rePathCall }
  }

  /**
   * A call to `django.urls.re_path`.
   *
   * See https://docs.djangoproject.com/en/3.0/ref/urls/#re_path
   */
  private class DjangoUrlsRePathCall extends DjangoRouteSetup {
    override CallNode node;

    DjangoUrlsRePathCall() { node.getFunction() = django::urls::re_path().asCfgNode() }

    override DataFlow::Node getUrlPatternArg() {
      result.asCfgNode() = [node.getArg(0), node.getArgByName("route")]
    }

    override DjangoRouteHandler getARouteHandler() {
      exists(DataFlow::Node viewArg |
        viewArg.asCfgNode() in [node.getArg(1), node.getArgByName("view")] and
        djangoRouteHandlerFunctionTracker(result) = viewArg
      )
    }

    override Parameter getARoutedParameter() {
      // If we don't know the URL pattern, we simply mark all parameters as a routed
      // parameter. This should give us more RemoteFlowSources but could also lead to
      // more FPs. If this turns out to be the wrong tradeoff, we can always change our mind.
      exists(DjangoRouteHandler routeHandler | routeHandler = this.getARouteHandler() |
        not exists(this.getUrlPattern()) and
        result in [routeHandler.getArg(_), routeHandler.getArgByName(_)] and
        not result = any(int i | i <= routeHandler.getRequestParamIndex() | routeHandler.getArg(i))
      )
      or
      exists(DjangoRouteHandler routeHandler, DjangoUrlsRePathRegex regex |
        routeHandler = this.getARouteHandler() and
        regex.getRePathCall() = this
      |
        // either using named capture groups (passed as keyword arguments) or using
        // unnamed capture groups (passed as positional arguments)
        not exists(regex.getGroupName(_, _)) and
        // first group will have group number 1
        result =
          routeHandler.getArg(routeHandler.getRequestParamIndex() + regex.getGroupNumber(_, _))
        or
        result = routeHandler.getArgByName(regex.getGroupName(_, _))
      )
    }
  }

  // ---------------------------------------------------------------------------
  // HttpRequest taint modeling
  // ---------------------------------------------------------------------------
  class DjangoRouteHandlerRequestParam extends django::http::request::HttpRequest::InstanceSource,
    RemoteFlowSource::Range, DataFlow::ParameterNode {
    DjangoRouteHandlerRequestParam() {
      this.getParameter() = any(DjangoRouteSetup setup).getARouteHandler().getRequestParam()
    }

    override string getSourceType() { result = "django.http.request.HttpRequest" }
  }

}
