/**
 * Provides classes related to the namespace `System.Text.RegularExpressions`.
 */

import default
import semmle.code.csharp.frameworks.system.Text
private import semmle.code.csharp.dataflow.ExternalFlow

/** The `System.Text.RegularExpressions` namespace. */
class SystemTextRegularExpressionsNamespace extends Namespace {
  SystemTextRegularExpressionsNamespace() {
    this.getParentNamespace() instanceof SystemTextNamespace and
    this.hasName("RegularExpressions")
  }
}

/** A class in the `System.Text.RegularExpressions` namespace. */
class SystemTextRegularExpressionsClass extends Class {
  SystemTextRegularExpressionsClass() {
    this.getNamespace() instanceof SystemTextRegularExpressionsNamespace
  }
}

/** The `System.Text.RegularExpressions.Regex` class. */
class SystemTextRegularExpressionsRegexClass extends SystemTextRegularExpressionsClass {
  SystemTextRegularExpressionsRegexClass() { this.hasName("Regex") }

  /** Gets a `Replace` method. */
  Method getAReplaceMethod() { result = this.getAMethod("Replace") }

  /** Gets a `Match` method. */
  Method getAMatchMethod() { result = this.getAMethod("Match") }
}

/**
 * A call to `System.AppDomain.SetData` that sets the global regex timeout.
 */
class RegexGlobalTimeout extends MethodCall {
  RegexGlobalTimeout() {
    this.getTarget().hasQualifiedName("System.AppDomain.SetData") and
    this.getArgumentForName("name").getValue() = "REGEX_DEFAULT_MATCH_TIMEOUT"
  }
}

/**
 * An operation that accepts a regular expression pattern.
 */
class RegexOperation extends Call {
  Expr pattern;

  RegexOperation() {
    this.getTarget() = any(SystemTextRegularExpressionsRegexClass r).getAMember() and
    pattern = this.getArgumentForName("pattern")
  }

  /** Gets the `pattern` argument. */
  Expr getPattern() { result = pattern }

  /** Holds if this regular expression has a timeout. */
  predicate hasTimeout() { exists(this.getArgumentForName("matchTimeout")) }

  /**
   * Gets an `input` argument used with this regex.
   *
   * This performs a local search for input used with this regular expression. This tracks from the
   * construction of a `Regex` object to any local uses to pattern match, or for any cases where
   * the `Regex` is declared in a field.
   */
  Expr getInput() {
    if this instanceof MethodCall
    then result = this.getArgumentForName("input")
    else
      exists(MethodCall call |
        call.getTarget() = any(SystemTextRegularExpressionsRegexClass rs).getAMethod() and
        result = call.getArgumentForName("input")
      |
        // e.g. `new Regex(...).Match(...)`
        // or   `var r = new Regex(...); r.Match(...)`
        DataFlow::localExprFlow(this, call.getQualifier())
        or
        // e.g. `private string r = new Regex(...); public void foo() { r.Match(...); }`
        call.getQualifier().(FieldAccess).getTarget().getInitializer() = this
      )
  }
}

/** Data flow for `System.Text.RegularExpressions.CaptureCollection`. */
private class SystemTextRegularExpressionsCaptureCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Text.RegularExpressions;CaptureCollection;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value"
  }
}

/** Data flow for `System.Text.RegularExpressions.GroupCollection`. */
private class SystemTextRegularExpressionsGroupCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Text.RegularExpressions;GroupCollection;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Text.RegularExpressions;GroupCollection;false;get_Item;(System.String);;Argument[Qualifier].Element;ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Text.RegularExpressions.MatchCollection`. */
private class SystemTextRegularExpressionsMatchCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Text.RegularExpressions;MatchCollection;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value"
  }
}
