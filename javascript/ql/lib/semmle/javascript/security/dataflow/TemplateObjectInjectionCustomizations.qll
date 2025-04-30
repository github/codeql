/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * template object injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript
private import semmle.javascript.security.TaintedObjectCustomizations

/**
 * Provides sources, sinks and sanitizers for reasoning about
 * template object injection vulnerabilities.
 */
module TemplateObjectInjection {
  import semmle.javascript.security.CommonFlowState

  /**
   * A data flow source for template object injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a flow state for which this is a source. */
    FlowState getAFlowState() { result.isTaint() }

    /** DEPRECATED. Use `getAFlowState()` instead */
    deprecated DataFlow::FlowLabel getAFlowLabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /**
   * A data flow sink for template object injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for template object injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  private class TaintedObjectSourceAsSource extends Source instanceof TaintedObject::Source {
    override FlowState getAFlowState() { result.isTaintedObject() }
  }

  /** An active threat-model source, considered as a flow source. */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource {
    override FlowState getAFlowState() { result.isTaint() }
  }

  /**
   * An argument given to the `render` method on an Express response object,
   * where the view engine used by the Express instance is vulnerable to template object injection.
   */
  private class TemplateSink extends Sink, Express::TemplateObjectInput {
    TemplateSink() {
      exists(
        Express::RouteSetup setup, Express::RouterDefinition router, Express::RouterDefinition top
      |
        setup.getARouteHandler() = this.getRouteHandler() and
        setup.getRouter() = router and
        top.getASubRouter*() = router and
        usesVulnerableTemplateEngine(top)
      )
    }
  }

  /**
   * Gets the package name for a templating library that is vulnerable to template object injection.
   */
  private string getAVulnerableTemplateEngine() {
    result =
      [
        "eta", "squirrelly", "haml-coffee", "express-hbs", "ejs", "hbs", "whiskers",
        "express-handlebars"
      ]
  }

  /**
   * Holds if the "view engine" of `router` is set to a vulnerable templating engine.
   */
  predicate usesVulnerableTemplateEngine(Express::RouterDefinition router) {
    // option 1: `app.set("view engine", "theEngine")`.
    // Express will load the engine automatically.
    exists(DataFlow::MethodCallNode call |
      router.ref().getAMethodCall() = call and
      call.getMethodName() = "set" and
      call.getArgument(0).getStringValue() = "view engine" and
      call.getArgument(1).getStringValue() = getAVulnerableTemplateEngine()
    )
    or
    // option 2: setup an engine.
    // ```app.engine("name", engine); app.set("view engine", "name");```
    // ^^^ `registerCall` ^^^         ^^^ `viewEngineCall` ^^^
    exists(
      DataFlow::MethodCallNode registerCall, DataFlow::SourceNode engine,
      DataFlow::MethodCallNode viewEngineCall
    |
      // `app.engine("name", engine)
      router.ref().getAMethodCall() = registerCall and
      registerCall.getMethodName() = ["engine", "register"] and
      engine = registerCall.getArgument(1).getALocalSource() and
      // app.set("view engine", "name")
      router.ref().getAMethodCall() = viewEngineCall and
      viewEngineCall.getMethodName() = "set" and
      viewEngineCall.getArgument(0).getStringValue() = "view engine" and
      // The name set by the `app.engine("name")` call matches `app.set("view engine", "name")`.
      (
        viewEngineCall.getArgument(1).getStringValue() =
          registerCall.getArgument(0).getStringValue()
        or
        "." + viewEngineCall.getArgument(1).getStringValue() =
          registerCall.getArgument(0).getStringValue()
      )
    |
      // Different ways of initializing vulnerable template engines.
      engine = DataFlow::moduleImport(getAVulnerableTemplateEngine())
      or
      engine = DataFlow::moduleImport(getAVulnerableTemplateEngine()).getAPropertyRead("__express")
      or
      engine = DataFlow::moduleImport("express-handlebars").getACall()
      or
      engine = DataFlow::moduleImport("express-handlebars").getAPropertyRead("engine")
      or
      exists(DataFlow::SourceNode hbs |
        hbs = DataFlow::moduleImport("express-hbs")
        or
        hbs = DataFlow::moduleImport("express-hbs").getAMemberCall("create")
      |
        engine = hbs.getAMemberCall(["express3", "express4"])
      )
      or
      engine =
        DataFlow::moduleImport("consolidate").getAPropertyRead(getAVulnerableTemplateEngine())
    )
  }
}
