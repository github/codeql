/**
 * Provides definitions related to string formatting.
 */

import csharp
private import semmle.code.csharp.commons.Collections
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.Text

/** A method that formats a string, for example `string.Format()`. */
abstract private class FormatMethodImpl extends Method {
  /**
   * Gets the argument containing the format string. For example, the argument of
   * `string.Format(IFormatProvider, String, Object)` is `1`.
   */
  abstract int getFormatArgument();

  /**
   * Gets the argument number of the first supplied insert.
   */
  int getFirstArgument() { result = this.getFormatArgument() + 1 }
}

final class FormatMethod = FormatMethodImpl;

/** A class of types used for formatting. */
private class FormatType extends Type {
  FormatType() {
    this instanceof StringType or
    this instanceof SystemTextCompositeFormatClass
  }
}

private class StringAndStringBuilderFormatMethods extends FormatMethodImpl {
  StringAndStringBuilderFormatMethods() {
    (
      this.getParameter(0).getType() instanceof SystemIFormatProviderInterface and
      this.getParameter(1).getType() instanceof FormatType
      or
      this.getParameter(0).getType() instanceof StringType
    ) and
    (
      this = any(SystemStringClass c).getFormatMethod()
      or
      this = any(SystemTextStringBuilderClass c).getAppendFormatMethod()
    )
  }

  override int getFormatArgument() {
    if this.getParameter(0).getType() instanceof SystemIFormatProviderInterface
    then result = 1
    else result = 0
  }
}

private class SystemMemoryExtensionsFormatMethods extends FormatMethodImpl {
  SystemMemoryExtensionsFormatMethods() {
    this = any(SystemMemoryExtensionsClass c).getTryWriteMethod() and
    this.getParameter(1).getType() instanceof SystemIFormatProviderInterface and
    this.getParameter(2).getType() instanceof SystemTextCompositeFormatClass
  }

  override int getFormatArgument() { result = 2 }

  override int getFirstArgument() { result = this.getFormatArgument() + 2 }
}

private class SystemConsoleAndSystemIoTextWriterFormatMethods extends FormatMethodImpl {
  SystemConsoleAndSystemIoTextWriterFormatMethods() {
    this.getParameter(0).getType() instanceof StringType and
    this.getNumberOfParameters() > 1 and
    exists(Class declType | declType = this.getDeclaringType() |
      this.hasName(["Write", "WriteLine"]) and
      (
        declType.hasFullyQualifiedName("System", "Console")
        or
        declType.hasFullyQualifiedName("System.IO", "TextWriter")
      )
    )
  }

  override int getFormatArgument() { result = 0 }
}

private class SystemDiagnosticsDebugAssert extends FormatMethodImpl {
  SystemDiagnosticsDebugAssert() {
    this.hasName("Assert") and
    this.getDeclaringType().hasFullyQualifiedName("System.Diagnostics", "Debug") and
    this.getNumberOfParameters() = 4
  }

  override int getFormatArgument() { result = 2 }
}

private class SystemDiagnosticsFormatMethods extends FormatMethodImpl {
  SystemDiagnosticsFormatMethods() {
    this.getParameter(0).getType() instanceof StringType and
    this.getNumberOfParameters() > 1 and
    exists(Class declType |
      declType = this.getDeclaringType() and
      declType.getNamespace().getFullName() = "System.Diagnostics"
    |
      declType.hasName("Trace") and
      (
        this.hasName("TraceError")
        or
        this.hasName("TraceInformation")
        or
        this.hasName("TraceWarning")
      )
      or
      declType.hasName("TraceSource") and this.hasName("TraceInformation")
      or
      declType.hasName("Debug") and
      (
        this.hasName("Print")
        or
        this.hasName(["Write", "WriteLine"]) and
        this.getParameter(1).getType() instanceof ArrayType
      )
    )
  }

  override int getFormatArgument() { result = 0 }
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
  int getFirstArgument() { result = this.getTarget().(FormatMethod).getFirstArgument() }

  /** Holds if this call has one or more insertions. */
  predicate hasInsertions() { exists(this.getArgument(this.getFirstArgument())) }

  /**
   * DEPRECATED: use `hasCollectionExpr` instead.
   *
   * Holds if the arguments are supplied in an array, not individually.
   */
  deprecated predicate hasArrayExpr() {
    this.getNumberOfArguments() = this.getFirstArgument() + 1 and
    this.getArgument(this.getFirstArgument()).getType() instanceof ArrayType
  }

  /**
   * Holds if the arguments are supplied in a collection, not individually.
   */
  predicate hasCollectionExpr() {
    this.getNumberOfArguments() = this.getFirstArgument() + 1 and
    this.getArgument(this.getFirstArgument()).getType() instanceof ParamsCollectionType
  }

  /**
   * Gets the number of supplied arguments (excluding the format string and format
   * provider). Does not return a value if the arguments are supplied in an array,
   * in which case we generally can't assess the size of the array.
   */
  int getSuppliedArguments() {
    not this.hasCollectionExpr() and
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

/**
 * A method call to a method that parses a format string, for example a call
 * to `string.Format()`.
 */
abstract private class FormatStringParseCallImpl extends MethodCall {
  /**
   * Gets the expression used as the format string.
   */
  abstract Expr getFormatExpr();
}

final class FormatStringParseCall = FormatStringParseCallImpl;

private class OrdinaryFormatCall extends FormatStringParseCallImpl instanceof FormatCall {
  override Expr getFormatExpr() { result = FormatCall.super.getFormatExpr() }
}

/**
 * A method call to `System.Text.CompositeFormat.Parse`.
 */
class ParseFormatStringCall extends FormatStringParseCallImpl {
  ParseFormatStringCall() {
    this.getTarget() = any(SystemTextCompositeFormatClass x).getParseMethod()
  }

  override Expr getFormatExpr() { result = this.getArgument(0) }
}
