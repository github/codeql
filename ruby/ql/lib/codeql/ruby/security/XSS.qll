/**
 * Provides classes and predicates used by the XSS queries.
 */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.DataFlow2
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.Frameworks
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.frameworks.ActionView
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.dataflow.BarrierGuards
private import codeql.ruby.dataflow.internal.DataFlowDispatch

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "server-side cross-site scripting" vulnerabilities, as well as
 * extension points for adding your own.
 */
private module Shared {
  /**
   * A data flow source for "server-side cross-site scripting" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "server-side cross-site scripting" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "server-side cross-site scripting" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for "server-side cross-site scripting" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  private class ErbOutputMethodCallArgumentNode extends DataFlow::Node {
    private MethodCall call;

    ErbOutputMethodCallArgumentNode() {
      exists(ErbOutputDirective d |
        call = d.getTerminalStmt() and
        this.asExpr().getExpr() = call.getAnArgument()
      )
    }

    MethodCall getCall() { result = call }
  }

  /**
   * An `html_safe` call marking the output as not requiring HTML escaping,
   * considered as a flow sink.
   */
  class HtmlSafeCallAsSink extends Sink {
    HtmlSafeCallAsSink() {
      exists(HtmlSafeCall c, ErbOutputDirective d |
        this.asExpr().getExpr() = c.getReceiver() and
        c = d.getTerminalStmt()
      )
    }
  }

  /**
   * An argument to a call to the `raw` method, considered as a flow sink.
   */
  class RawCallArgumentAsSink extends Sink, ErbOutputMethodCallArgumentNode {
    RawCallArgumentAsSink() { this.getCall() instanceof RawCall }
  }

  /**
   * A argument to a call to the `link_to` method, which does not expect
   * unsanitized user-input, considered as a flow sink.
   */
  class LinkToCallArgumentAsSink extends Sink, ErbOutputMethodCallArgumentNode {
    LinkToCallArgumentAsSink() {
      this.asExpr().getExpr() = this.getCall().(LinkToCall).getPathArgument()
    }
  }

  /**
   * An HTML escaping, considered as a sanitizer.
   */
  class HtmlEscapingAsSanitizer extends Sanitizer {
    HtmlEscapingAsSanitizer() { this = any(HtmlEscaping esc).getOutput() }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends SanitizerGuard, StringConstCompare { }

  /**
   * An inclusion check against an array of constant strings, considered as a sanitizer-guard.
   */
  class StringConstArrayInclusionCallAsSanitizerGuard extends SanitizerGuard,
    StringConstArrayInclusionCall { }

  /**
   * A `VariableWriteAccessCfgNode` that is not succeeded (locally) by another
   * write to that variable.
   */
  private class FinalInstanceVarWrite extends CfgNodes::ExprNodes::InstanceVariableWriteAccessCfgNode {
    private InstanceVariable var;

    FinalInstanceVarWrite() {
      var = this.getExpr().getVariable() and
      not exists(CfgNodes::ExprNodes::InstanceVariableWriteAccessCfgNode succWrite |
        succWrite.getExpr().getVariable() = var
      |
        succWrite = this.getASuccessor+()
      )
    }

    InstanceVariable getVariable() { result = var }

    AssignExpr getAnAssignExpr() { result.getLeftOperand() = this.getExpr() }
  }

  /**
   * Holds if `call` is a method call in ERB file `erb`, targeting a method
   * named `name`.
   */
  pragma[noinline]
  private predicate isMethodCall(MethodCall call, string name, ErbFile erb) {
    name = call.getMethodName() and
    erb = call.getLocation().getFile()
  }

  /**
   * Holds if some render call passes `value` for `hashKey` in the `locals`
   * argument, in ERB file `erb`.
   */
  pragma[noinline]
  private predicate renderCallLocals(string hashKey, Expr value, ErbFile erb) {
    exists(RenderCall call, Pair kvPair |
      call.getLocals().getAKeyValuePair() = kvPair and
      kvPair.getValue() = value and
      kvPair.getKey().getConstantValue().isStringlikeValue(hashKey) and
      call.getTemplateFile() = erb
    )
  }

  pragma[noinline]
  private predicate isFlowFromLocals0(
    CfgNodes::ExprNodes::ElementReferenceCfgNode refNode, string hashKey, ErbFile erb
  ) {
    exists(DataFlow::Node argNode, CfgNodes::ExprNodes::StringlikeLiteralCfgNode strNode |
      argNode.asExpr() = refNode.getArgument(0) and
      refNode.getReceiver().getExpr().(MethodCall).getMethodName() = "local_assigns" and
      argNode.getALocalSource() = DataFlow::exprNode(strNode) and
      strNode.getExpr().getConstantValue().isStringlikeValue(hashKey) and
      erb = refNode.getFile()
    )
  }

  private predicate isFlowFromLocals(DataFlow::Node node1, DataFlow::Node node2) {
    exists(string hashKey, ErbFile erb |
      // node1 is a `locals` argument to a render call...
      renderCallLocals(hashKey, node1.asExpr().getExpr(), erb)
    |
      // node2 is an element reference against `local_assigns`
      isFlowFromLocals0(node2.asExpr(), hashKey, erb)
      or
      // ...node2 is a "method call" to a "method" with `hashKey` as its name
      // TODO: This may be a variable read in reality that we interpret as a method call
      isMethodCall(node2.asExpr().getExpr(), hashKey, erb)
    )
  }

  /**
   * Holds if `action` contains an assignment of `value` to an instance
   * variable named `name`, in ERB file `erb`.
   */
  pragma[noinline]
  private predicate actionAssigns(
    ActionControllerActionMethod action, string name, Expr value, ErbFile erb
  ) {
    exists(AssignExpr ae, FinalInstanceVarWrite controllerVarWrite |
      action.getDefaultTemplateFile() = erb and
      ae.getParent+() = action and
      ae = controllerVarWrite.getAnAssignExpr() and
      name = controllerVarWrite.getVariable().getName() and
      value = ae.getRightOperand()
    )
  }

  pragma[noinline]
  private predicate isVariableReadAccess(VariableReadAccess viewVarRead, string name, ErbFile erb) {
    erb = viewVarRead.getLocation().getFile() and
    viewVarRead.getVariable().getName() = name
  }

  private predicate isFlowFromControllerInstanceVariable(DataFlow::Node node1, DataFlow::Node node2) {
    // instance variables in the controller
    exists(ActionControllerActionMethod action, string name, ErbFile template |
      // match read to write on variable name
      actionAssigns(action, name, node1.asExpr().getExpr(), template) and
      // propagate taint from assignment RHS expr to variable read access in view
      isVariableReadAccess(node2.asExpr().getExpr(), name, template)
    )
  }

  /**
   * Holds if `helperMethod` is a helper method named `name` that is associated
   * with ERB file `erb`.
   */
  pragma[noinline]
  private predicate isHelperMethod(
    ActionControllerHelperMethod helperMethod, string name, ErbFile erb
  ) {
    helperMethod.getName() = name and
    helperMethod.getControllerClass() = getAssociatedControllerClass(erb)
  }

  private predicate isFlowIntoHelperMethod(DataFlow::Node node1, DataFlow::Node node2) {
    // flow from template into controller helper method
    exists(
      ErbFile template, ActionControllerHelperMethod helperMethod, string name,
      CfgNodes::ExprNodes::MethodCallCfgNode helperMethodCall, int argIdx
    |
      isHelperMethod(helperMethod, name, template) and
      isMethodCall(helperMethodCall.getExpr(), name, template) and
      helperMethodCall.getArgument(pragma[only_bind_into](argIdx)) = node1.asExpr() and
      helperMethod.getParameter(pragma[only_bind_into](argIdx)) = node2.asParameter()
    )
  }

  private predicate isFlowFromHelperMethod(DataFlow::Node node1, DataFlow::Node node2) {
    // flow out of controller helper method into template
    exists(ErbFile template, ActionControllerHelperMethod helperMethod, string name |
      // `node1` is an expr node that may be returned by the helper method
      exprNodeReturnedFrom(node1, helperMethod) and
      // `node2` is a call to the helper method
      isHelperMethod(helperMethod, name, template) and
      isMethodCall(node2.asExpr().getExpr(), name, template)
    )
  }

  /**
   * An additional step that is preserves dataflow in the context of XSS.
   */
  predicate isAdditionalXssFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    isFlowFromLocals(node1, node2)
    or
    isFlowFromControllerInstanceVariable(node1, node2)
    or
    isFlowIntoHelperMethod(node1, node2)
    or
    isFlowFromHelperMethod(node1, node2)
  }

  /** DEPRECATED: Alias for isAdditionalXssFlowStep */
  deprecated predicate isAdditionalXSSFlowStep = isAdditionalXssFlowStep/2;
}

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "reflected cross-site scripting" vulnerabilities, as well as
 * extension points for adding your own.
 */
module ReflectedXss {
  /** A data flow source for stored XSS vulnerabilities. */
  abstract class Source extends Shared::Source { }

  /** A data flow sink for stored XSS vulnerabilities. */
  class Sink = Shared::Sink;

  /** A sanitizer for stored XSS vulnerabilities. */
  class Sanitizer = Shared::Sanitizer;

  /** A sanitizer guard for stored XSS vulnerabilities. */
  class SanitizerGuard = Shared::SanitizerGuard;

  /**
   * An additional step that is preserves dataflow in the context of reflected XSS.
   */
  predicate isAdditionalXssTaintStep = Shared::isAdditionalXssFlowStep/2;

  /** DEPRECATED: Alias for isAdditionalXssTaintStep */
  deprecated predicate isAdditionalXSSTaintStep = isAdditionalXssTaintStep/2;

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }
}

/** DEPRECATED: Alias for ReflectedXss */
deprecated module ReflectedXSS = ReflectedXss;

private module OrmTracking {
  /**
   * A data flow configuration to track flow from finder calls to field accesses.
   */
  class Configuration extends DataFlow2::Configuration {
    Configuration() { this = "OrmTracking" }

    override predicate isSource(DataFlow2::Node source) { source instanceof OrmInstantiation }

    // Select any call node and narrow down later
    override predicate isSink(DataFlow2::Node sink) { sink instanceof DataFlow2::CallNode }

    override predicate isAdditionalFlowStep(DataFlow2::Node node1, DataFlow2::Node node2) {
      Shared::isAdditionalXssFlowStep(node1, node2)
      or
      // Propagate flow through arbitrary method calls
      node2.(DataFlow2::CallNode).getReceiver() = node1
      or
      // Propagate flow through "or" expressions `or`/`||`
      node2.asExpr().getExpr().(LogicalOrExpr).getAnOperand() = node1.asExpr().getExpr()
    }
  }
}

/** Provides default sources, sinks and sanitizers for detecting stored cross-site scripting (XSS) vulnerabilities. */
module StoredXss {
  /** A data flow source for stored XSS vulnerabilities. */
  abstract class Source extends Shared::Source { }

  /** A data flow sink for stored XSS vulnerabilities. */
  class Sink = Shared::Sink;

  /** A sanitizer for stored XSS vulnerabilities. */
  class Sanitizer = Shared::Sanitizer;

  /** A sanitizer guard for stored XSS vulnerabilities. */
  class SanitizerGuard = Shared::SanitizerGuard;

  /**
   * An additional step that preserves dataflow in the context of stored XSS.
   */
  predicate isAdditionalXssTaintStep = Shared::isAdditionalXssFlowStep/2;

  /** DEPRECATED: Alias for isAdditionalXssTaintStep */
  deprecated predicate isAdditionalXSSTaintStep = isAdditionalXssTaintStep/2;

  private class OrmFieldAsSource extends Source instanceof DataFlow2::CallNode {
    OrmFieldAsSource() {
      exists(OrmTracking::Configuration subConfig, DataFlow2::CallNode subSrc, MethodCall call |
        subConfig.hasFlow(subSrc, this) and
        call = this.asExpr().getExpr() and
        subSrc.(OrmInstantiation).methodCallMayAccessField(call.getMethodName())
      )
    }
  }

  /** A file read, considered as a flow source for stored XSS. */
  private class FileSystemReadAccessAsSource extends Source instanceof FileSystemReadAccess { }
  // TODO: Consider `FileNameSource` flowing to script tag `src` attributes and similar
}

/** DEPRECATED: Alias for StoredXss */
deprecated module StoredXSS = StoredXss;
