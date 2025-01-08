/**
 * Provides definitions related to string formatting.
 */

import csharp
private import semmle.code.csharp.commons.Collections
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.Text

/** A method that formats a string, for example `string.Format()`. */
class FormatMethod extends Method {
  FormatMethod() {
    exists(Class declType | declType = this.getDeclaringType() |
      this.getParameter(0).getType() instanceof SystemIFormatProviderInterface and
      this.getParameter(1).getType() instanceof StringType and
      (
        this = any(SystemStringClass c).getFormatMethod()
        or
        this = any(SystemTextStringBuilderClass c).getAppendFormatMethod()
      )
      or
      this.getParameter(0).getType() instanceof StringType and
      (
        this = any(SystemStringClass c).getFormatMethod()
        or
        this = any(SystemTextStringBuilderClass c).getAppendFormatMethod()
        or
        (this.hasName("Write") or this.hasName("WriteLine")) and
        (
          declType.hasFullyQualifiedName("System", "Console")
          or
          declType.hasFullyQualifiedName("System.IO", "TextWriter")
          or
          declType.hasFullyQualifiedName("System.Diagnostics", "Debug") and
          this.getParameter(1).getType() instanceof ArrayType
        )
        or
        declType.hasFullyQualifiedName("System.Diagnostics", "Trace") and
        (
          this.hasName("TraceError") or
          this.hasName("TraceInformation") or
          this.hasName("TraceWarning")
        )
        or
        this.hasName("TraceInformation") and
        declType.hasFullyQualifiedName("System.Diagnostics", "TraceSource")
        or
        this.hasName("Print") and
        declType.hasFullyQualifiedName("System.Diagnostics", "Debug")
      )
      or
      this.hasName("Assert") and
      declType.hasFullyQualifiedName("System.Diagnostics", "Debug") and
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
        this.getDeclaringType().hasFullyQualifiedName("System.Diagnostics", "Debug")
      then result = 2
      else result = 0
  }
}

pragma[nomagic]
private predicate parameterReadPostDominatesEntry(ParameterRead pr) {
  pr.getAControlFlowNode().postDominates(pr.getEnclosingCallable().getEntryPoint()) and
  getParameterType(pr.getTarget()) instanceof ObjectType
}

pragma[nomagic]
private predicate alwaysPassedToFormatItemParameter(ParameterRead pr) {
  pr = any(StringFormatItemParameter other).getAnAssignedArgument() and
  parameterReadPostDominatesEntry(pr)
  or
  alwaysPassedToFormatItemParameter(pr.getANextRead())
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
    exists(AssignableDefinitions::ImplicitParameterDefinition def |
      def.getParameter() = this and
      alwaysPassedToFormatItemParameter(def.getAFirstRead())
    )
  }
}

private Type getParameterType(Parameter p) {
  if p.isParams()
  then result = p.getType().(ParamsCollectionType).getElementType()
  else result = p.getType()
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

  /** Gets the insert number at the given position in the string. */
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
      startcolumn = padding + oldstartcolumn + this.getInvalidOffset() and
      toUrl(filepath, startline, startcolumn, endline, endcolumn, result)
    |
      // Single-line string literal beginning " or @"
      // Figure out the correct indent.
      startline = endline and
      padding = endcolumn - oldstartcolumn - this.getValue().length()
      or
      // Multi-line literal beginning @"
      startline != endline and
      padding = 2
    )
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

  /** Holds if this call has one or more insertions. */
  predicate hasInsertions() { exists(this.getArgument(this.getFirstArgument())) }

  /** Holds if the arguments are supplied in an array, not individually. */
  predicate hasArrayExpr() {
    this.getNumberOfArguments() = this.getFirstArgument() + 1 and
    this.getArgument(this.getFirstArgument()).getType() instanceof ArrayType
  }

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
}
