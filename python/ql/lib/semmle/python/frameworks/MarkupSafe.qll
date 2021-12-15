/**
 * Provides classes modeling security-relevant aspects of the `MarkupSafe` PyPI package.
 * See https://markupsafe.palletsprojects.com/en/2.0.x/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper

/**
 * Provides models for the `MarkupSafe` PyPI package.
 * See https://markupsafe.palletsprojects.com/en/2.0.x/.
 */
private module MarkupSafeModel {
  /**
   * Provides models for the `markupsafe.Markup` class
   *
   * See https://markupsafe.palletsprojects.com/en/2.0.x/escaping/#markupsafe.Markup.
   */
  module Markup {
    /** Gets a reference to the `markupsafe.Markup` class. */
    API::Node classRef() {
      result = API::moduleImport("markupsafe").getMember("Markup")
      or
      result = API::moduleImport("flask").getMember("Markup")
    }

    /**
     * A source of instances of `markupsafe.Markup`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `Markup::instance()` to get references to instances of `markupsafe.Markup`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of `markupsafe.Markup`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      override CallNode node;

      ClassInstantiation() { this = classRef().getACall() }
    }

    /** Gets a reference to an instance of `markupsafe.Markup`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `markupsafe.Markup`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /** A string concatenation with a `markupsafe.Markup` involved. */
    class StringConcat extends Markup::InstanceSource, DataFlow::CfgNode {
      override BinaryExprNode node;

      StringConcat() {
        node.getOp() instanceof Add and
        instance().asCfgNode() in [node.getLeft(), node.getRight()]
      }
    }

    /** A string format with `markupsafe.Markup` as the format string. */
    class StringFormat extends Markup::InstanceSource, DataFlow::MethodCallNode {
      StringFormat() { this.calls(instance(), "format") }
    }

    /** A %-style string format with `markupsafe.Markup` as the format string. */
    class PercentStringFormat extends Markup::InstanceSource, DataFlow::CfgNode {
      override BinaryExprNode node;

      PercentStringFormat() {
        node.getOp() instanceof Mod and
        instance().asCfgNode() = node.getLeft()
      }
    }

    /** Taint propagation for `markupsafe.Markup`. */
    private class AddtionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        nodeTo.(ClassInstantiation).getArg(0) = nodeFrom
      }
    }
  }

  /** Any escaping performed via the `markupsafe` package. */
  abstract private class MarkupSafeEscape extends Escaping::Range {
    override string getKind() {
      // TODO: this package claims to escape for both HTML and XML, but for now we don't
      // model XML.
      result = Escaping::getHtmlKind()
    }
  }

  /** A call to any of the escaping functions in `markupsafe` */
  private class MarkupSafeEscapeCall extends Markup::InstanceSource, MarkupSafeEscape,
    DataFlow::CallCfgNode {
    MarkupSafeEscapeCall() {
      this = API::moduleImport("markupsafe").getMember(["escape", "escape_silent"]).getACall()
      or
      this = Markup::classRef().getMember("escape").getACall()
      or
      this = API::moduleImport("flask").getMember("escape").getACall()
    }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override DataFlow::Node getOutput() { result = this }
  }

  /**
   * An escape from string concatenation with a `markupsafe.Markup` involved.
   *
   * Only things that are not already a `markupsafe.Markup` instances will be escaped.
   */
  private class MarkupEscapeFromStringConcat extends MarkupSafeEscape, Markup::StringConcat {
    override DataFlow::Node getAnInput() {
      result.asCfgNode() in [node.getLeft(), node.getRight()] and
      not result = Markup::instance()
    }

    override DataFlow::Node getOutput() { result = this }
  }

  /** A escape from string format with `markupsafe.Markup` as the format string. */
  private class MarkupEscapeFromStringFormat extends MarkupSafeEscape, Markup::StringFormat {
    override DataFlow::Node getAnInput() {
      result in [this.getArg(_), this.getArgByName(_)] and
      not result = Markup::instance()
    }

    override DataFlow::Node getOutput() { result = this }
  }

  /** A escape from %-style string format with `markupsafe.Markup` as the format string. */
  private class MarkupEscapeFromPercentStringFormat extends MarkupSafeEscape,
    Markup::PercentStringFormat {
    override DataFlow::Node getAnInput() {
      result.asCfgNode() = node.getRight() and
      not result = Markup::instance()
    }

    override DataFlow::Node getOutput() { result = this }
  }
}
