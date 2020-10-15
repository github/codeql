/**
 * Provides classes modeling security-relevant aspects of the `django` PyPI package.
 * See https://www.djangoproject.com/.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.semmle.python.Concepts

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
    attr_name in ["urls"] and
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
    /** Gets a reference to the `django.urls` module. */
    DataFlow::Node urls() { result = django_attr("urls") }

    // -------------------------------------------------------------------------
    // django.urls
    // -------------------------------------------------------------------------
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
  }

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
   * A call to `django.urls.path`.
   *
   * See https://docs.djangoproject.com/en/3.0/ref/urls/#path
   */
  private class DjangoUrlsPathCall extends HTTP::Server::RouteSetup::Range, DataFlow::CfgNode {
    override CallNode node;

    DjangoUrlsPathCall() { node.getFunction() = django::urls::path().asCfgNode() }

    override string getUrlPattern() {
      exists(StrConst str, ControlFlowNode urlPatternArg |
        urlPatternArg = [node.getArg(0), node.getArgByName("route")]
      |
        DataFlow::localFlow(DataFlow::exprNode(str),
          any(DataFlow::Node n | n.asCfgNode() = urlPatternArg)) and
        result = str.getText()
      )
    }

    override Function getARouteHandler() {
      exists(DataFlow::Node viewArg |
        viewArg.asCfgNode() in [node.getArg(1), node.getArgByName("view")] and
        djangoRouteHandlerFunctionTracker(result) = viewArg
      )
    }

    override Parameter getARoutedParameter() { none() }
  }

  /**
   * A call to `django.urls.re_path`.
   *
   * See https://docs.djangoproject.com/en/3.0/ref/urls/#re_path
   */
  private class DjangoUrlsRePathCall extends HTTP::Server::RouteSetup::Range, DataFlow::CfgNode {
    override CallNode node;

    DjangoUrlsRePathCall() { node.getFunction() = django::urls::re_path().asCfgNode() }

    override string getUrlPattern() {
      exists(StrConst str, ControlFlowNode urlPatternArg |
        urlPatternArg = [node.getArg(0), node.getArgByName("route")]
      |
        DataFlow::localFlow(DataFlow::exprNode(str),
          any(DataFlow::Node n | n.asCfgNode() = urlPatternArg)) and
        result = str.getText()
      )
    }

    override Function getARouteHandler() {
      exists(DataFlow::Node viewArg |
        viewArg.asCfgNode() in [node.getArg(1), node.getArgByName("view")] and
        djangoRouteHandlerFunctionTracker(result) = viewArg
      )
    }

    override Parameter getARoutedParameter() { none() }
  }
}
