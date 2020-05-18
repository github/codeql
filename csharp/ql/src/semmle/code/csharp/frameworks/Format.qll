/**
 * Provides definitions related to string formatting.
 */

import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.Text
private import semmle.code.csharp.dataflow.DataFlow2

/** A method that formats a string, for example `string.Format()`. */
class FormatMethod extends Method {
  FormatMethod() {
    exists(Class declType | declType = this.getDeclaringType() |
      this.getParameter(0).getType() instanceof SystemIFormatProviderInterface and
      this.getParameter(1).getType() instanceof StringType and
      this.getNumberOfParameters() >= 3 and
      (
        this = any(SystemStringClass c).getFormatMethod()
        or
        this = any(SystemTextStringBuilderClass c).getAppendFormatMethod()
      )
      or
      this.getParameter(0).getType() instanceof StringType and
      this.getNumberOfParameters() >= 2 and
      (
        this = any(SystemStringClass c).getFormatMethod()
        or
        this = any(SystemTextStringBuilderClass c).getAppendFormatMethod()
        or
        (this.hasName("Write") or this.hasName("WriteLine")) and
        (
          declType.hasQualifiedName("System.Console")
          or
          declType.hasQualifiedName("System.IO.TextWriter")
          or
          declType.hasQualifiedName("System.Diagnostics.Debug") and
          this.getParameter(1).getType() instanceof ArrayType
        )
        or
        declType.hasQualifiedName("System.Diagnostics.Trace") and
        (
          this.hasName("TraceError") or
          this.hasName("TraceInformation") or
          this.hasName("TraceWarning")
        )
        or
        this.hasName("TraceInformation") and
        declType.hasQualifiedName("System.Diagnostics.TraceSource")
        or
        this.hasName("Print") and
        declType.hasQualifiedName("System.Diagnostics.Debug")
      )
      or
      this.hasName("Assert") and
      declType.hasQualifiedName("System.Diagnostics.Debug") and
      this.getNumberOfParameters() = 4
    )
  }

  /**
   * Gets the argument containing the format string. For example, the argument of
   * `string.Format(IFormatProvider, String, Object)` is `1`.
   */
  int getFormatArgument() {
    if this.getParameter(0).getType() instanceof SystemIFormatProviderInterface
    then result = 1
    else
      if
        this.hasName("Assert") and
        this.getDeclaringType().hasQualifiedName("System.Diagnostics.Debug")
      then result = 2
      else result = 0
  }
}

/**
 * A parameter that is used as a format item for `string.Format()`. Either a
 * format item parameter of `string.Format()`, or a parameter of a method that
 * is forwarded to a format item parameter of `string.Format()`.
 */
class StringFormatItemParameter extends Parameter {
  StringFormatItemParameter() {
    // Parameter of a format method
    exists(FormatMethod m, int pos | m = this.getCallable() |
      pos = this.getPosition() and
      pos > m.getFormatArgument()
    )
    or
    // Parameter of a source method that forwards to `string.Format()`
    exists(
      AssignableDefinitions::ImplicitParameterDefinition def, ParameterRead pr,
      StringFormatItemParameter other
    |
      def.getParameter() = this and
      pr = def.getAReachableRead() and
      pr.getAControlFlowNode().postDominates(this.getCallable().getEntryPoint()) and
      other.getAnAssignedArgument() = pr and
      getParameterType(this) instanceof ObjectType
    )
  }
}

private Type getParameterType(Parameter p) {
  if p.isParams() then result = p.getType().(ArrayType).getElementType() else result = p.getType()
}

/** Regex for a valid insert. */
private string getFormatInsertRegex() { result = "\\{(\\d+)\\s*(,\\s*-?\\d+\\s*)?(:[^{}]+)?\\}" }

/**
 * Regex for a valid token in the string.
 *
 * Note that the format string can be tokenised using this regex.
 */
private string getValidFormatTokenRegex() {
  result = "[^{}]|\\{\\{|\\}\\}|" + getFormatInsertRegex()
}

/** Regex for the entire format string */
private string getValidFormatRegex() { result = "(" + getValidFormatTokenRegex() + ")*+" }

/** A literal with a valid format string. */
class ValidFormatString extends StringLiteral {
  ValidFormatString() { this.getValue().regexpMatch(getValidFormatRegex()) }

  /** Gets the token at the given position in the string. */
  string getToken(int outPosition) {
    result = this.getValue().regexpFind(getValidFormatTokenRegex(), _, outPosition)
  }

  /**Gets the insert number at the given position in the string. */
  int getInsert(int position) {
    result = this.getToken(position).regexpCapture(getFormatInsertRegex(), 1).toInt()
  }

  /** Gets any insert number in the string. */
  int getAnInsert() { result = this.getInsert(_) }
}

/**
 * A literal with an invalid format string.
 *
 * Such a literal would cause `string.Format()` to throw an exception.
 */
class InvalidFormatString extends StringLiteral {
  InvalidFormatString() { not this.getValue().regexpMatch(getValidFormatRegex()) }

  /** Gets the offset of the first error. */
  int getInvalidOffset() {
    result = this.getValue().regexpFind(getValidFormatRegex(), 0, 0).length()
  }

  /** Gets the URL of this element. */
  string getURL() {
    exists(
      string filepath, int startline, int startcolumn, int endline, int endcolumn,
      int oldstartcolumn, int padding
    |
      this.getLocation().hasLocationInfo(filepath, startline, oldstartcolumn, endline, endcolumn) and
      startcolumn = padding + oldstartcolumn + getInvalidOffset() and
      toUrl(filepath, startline, startcolumn, endline, endcolumn, result)
    |
      // Single-line string literal beginning " or @"
      // Figure out the correct indent.
      startline = endline and
      padding = endcolumn - oldstartcolumn - getValue().length()
      or
      // Multi-line literal beginning @"
      startline != endline and
      padding = 2
    )
  }
}

/** Provides a dataflow configuration for format strings. */
module FormatFlow {
  private import semmle.code.csharp.dataflow.DataFlow

  private class FormatConfiguration extends DataFlow2::Configuration {
    FormatConfiguration() { this = "format" }

    override predicate isSource(DataFlow::Node n) { n.asExpr() instanceof StringLiteral }

    override predicate isSink(DataFlow::Node n) {
      exists(FormatCall c | n.asExpr() = c.getFormatExpr())
    }
  }

  query predicate nodes = DataFlow2::PathGraph::nodes/3;

  query predicate edges = DataFlow2::PathGraph::edges/2;

  class PathNode = DataFlow2::PathNode;

  /**
   * Holds if there is flow from string literal `lit` to the format string in
   * `call`. `litNode` and `formatNode` are the corresponding data-flow path
   * nodes.
   */
  predicate hasFlowPath(StringLiteral lit, PathNode litNode, FormatCall call, PathNode formatNode) {
    litNode.getNode().asExpr() = lit and
    formatNode.getNode().asExpr() = call.getFormatExpr() and
    any(FormatConfiguration conf).hasFlowPath(litNode, formatNode)
  }
}

/**
 * A method call to a method that formats a string, for example a call
 * to `string.Format()`.
 */
class FormatCall extends MethodCall {
  FormatCall() { this.getTarget() instanceof FormatMethod }

  /** Gets the expression used as the format string. */
  Expr getFormatExpr() { result = this.getArgument(this.getFormatArgument()) }

  /** Gets the argument number containing the format string. */
  int getFormatArgument() { result = this.getTarget().(FormatMethod).getFormatArgument() }

  /** Gets the argument number of the first supplied insert. */
  int getFirstArgument() { result = this.getFormatArgument() + 1 }

  /** Holds if the arguments are supplied in an array, not individually. */
  predicate hasArrayExpr() {
    this.getNumberOfArguments() = this.getFirstArgument() + 1 and
    this.getArgument(this.getFirstArgument()).getType() instanceof ArrayType
  }

  /**
   * DEPRECATED: Use `FormatFlow::hasFlowPath()` instead.
   *
   * Gets a format string. Global data flow analysis is applied to retrieve all
   * sources that can reach this method call.
   */
  deprecated StringLiteral getAFormatSource() { FormatFlow::hasFlowPath(result, _, this, _) }

  /**
   * Gets the number of supplied arguments (excluding the format string and format
   * provider). Does not return a value if the arguments are supplied in an array,
   * in which case we generally can't assess the size of the array.
   */
  int getSuppliedArguments() {
    not this.hasArrayExpr() and
    result = this.getNumberOfArguments() - this.getFirstArgument()
  }

  /** Gets an index if a supplied argument. */
  int getASuppliedArgument() { result in [0 .. this.getSuppliedArguments() - 1] }

  /** Get the expression supplied at the given position. */
  Expr getSuppliedExpr(int index) {
    index = this.getASuppliedArgument() and
    result = this.getArgument(this.getFirstArgument() + index)
  }

  /** Gets a supplied argument that is not used in the format string `src`. */
  int getAnUnusedArgument(ValidFormatString src) {
    result = this.getASuppliedArgument() and
    FormatFlow::hasFlowPath(src, _, this, _) and
    not result = src.getAnInsert()
  }
}
