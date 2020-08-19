/**
 * Provides classes and predicates for reasoning about string formatting.
 */

import java
import dataflow.DefUse

/**
 * A library method that formats a number of its arguments according to a
 * format string.
 */
abstract private class FormatMethod extends Method {
  /** Gets the index of the format string argument. */
  abstract int getFormatStringIndex();
}

/**
 * A library method that acts like `String.format` by formatting a number of
 * its arguments according to a format string.
 */
class StringFormatMethod extends FormatMethod {
  StringFormatMethod() {
    (
      this.hasName("format") or
      this.hasName("formatted") or
      this.hasName("printf") or
      this.hasName("readLine") or
      this.hasName("readPassword")
    ) and
    (
      this.getDeclaringType().hasQualifiedName("java.lang", "String") or
      this.getDeclaringType().hasQualifiedName("java.io", "PrintStream") or
      this.getDeclaringType().hasQualifiedName("java.io", "PrintWriter") or
      this.getDeclaringType().hasQualifiedName("java.io", "Console") or
      this.getDeclaringType().hasQualifiedName("java.util", "Formatter")
    )
  }

  override int getFormatStringIndex() {
    result = 0 and this.getSignature() = "format(java.lang.String,java.lang.Object[])"
    or
    result = -1 and this.getSignature() = "formatted(java.lang.Object[])"
    or
    result = 0 and this.getSignature() = "printf(java.lang.String,java.lang.Object[])"
    or
    result = 1 and
    this.getSignature() = "format(java.util.Locale,java.lang.String,java.lang.Object[])"
    or
    result = 1 and
    this.getSignature() = "printf(java.util.Locale,java.lang.String,java.lang.Object[])"
    or
    result = 0 and this.getSignature() = "readLine(java.lang.String,java.lang.Object[])"
    or
    result = 0 and this.getSignature() = "readPassword(java.lang.String,java.lang.Object[])"
  }
}

/**
 * A format method using the `org.slf4j.Logger` format string syntax. That is,
 * the placeholder string is `"{}"`.
 */
class LoggerFormatMethod extends FormatMethod {
  LoggerFormatMethod() {
    (
      this.hasName("debug") or
      this.hasName("error") or
      this.hasName("info") or
      this.hasName("trace") or
      this.hasName("warn")
    ) and
    this.getDeclaringType().getASourceSupertype*().hasQualifiedName("org.slf4j", "Logger")
  }

  override int getFormatStringIndex() {
    (result = 0 or result = 1) and
    this.getParameterType(result) instanceof TypeString
  }
}

private newtype TFmtSyntax =
  TFmtPrintf() or
  TFmtLogger()

/** A syntax for format strings. */
class FmtSyntax extends TFmtSyntax {
  /** Gets a textual representation of this format string syntax. */
  string toString() {
    result = "printf (%) syntax" and this = TFmtPrintf()
    or
    result = "logger ({}) syntax" and this = TFmtLogger()
  }

  /** Holds if this syntax is logger ({}) syntax. */
  predicate isLogger() { this = TFmtLogger() }
}

private Expr getArgumentOrQualifier(Call c, int i) {
  result = c.getArgument(i)
  or
  result = c.getQualifier() and i = -1
}

/**
 * Holds if `c` wraps a call to a `StringFormatMethod`, such that `fmtix` is
 * the index of the format string argument to `c` and the following and final
 * argument is the `Object[]` that holds the arguments to be formatted.
 */
private predicate formatWrapper(Callable c, int fmtix, FmtSyntax syntax) {
  exists(Parameter fmt, Parameter args, Call fmtcall, int i |
    fmt = c.getParameter(fmtix) and
    fmt.getType() instanceof TypeString and
    args = c.getParameter(fmtix + 1) and
    args.getType().(Array).getElementType() instanceof TypeObject and
    c.getNumberOfParameters() = fmtix + 2 and
    fmtcall.getEnclosingCallable() = c and
    (
      formatWrapper(fmtcall.getCallee(), i, syntax)
      or
      fmtcall.getCallee().(StringFormatMethod).getFormatStringIndex() = i and syntax = TFmtPrintf()
      or
      fmtcall.getCallee().(LoggerFormatMethod).getFormatStringIndex() = i and syntax = TFmtLogger()
    ) and
    getArgumentOrQualifier(fmtcall, i) = fmt.getAnAccess() and
    fmtcall.getArgument(i + 1) = args.getAnAccess()
  )
}

/**
 * A call to a `StringFormatMethod` or a callable wrapping a `StringFormatMethod`.
 */
class FormattingCall extends Call {
  FormattingCall() {
    this.getCallee() instanceof FormatMethod or
    formatWrapper(this.getCallee(), _, _)
  }

  /** Gets the index of the format string argument. */
  private int getFormatStringIndex() {
    this.getCallee().(FormatMethod).getFormatStringIndex() = result or
    formatWrapper(this.getCallee(), result, _)
  }

  /** Gets the format string syntax used by this call. */
  FmtSyntax getSyntax() {
    this.getCallee() instanceof StringFormatMethod and result = TFmtPrintf()
    or
    this.getCallee() instanceof LoggerFormatMethod and result = TFmtLogger()
    or
    formatWrapper(this.getCallee(), _, result)
  }

  private Expr getLastArg() {
    exists(Expr last | last = this.getArgument(this.getNumArgument() - 1) |
      if this.hasExplicitVarargsArray()
      then result = last.(ArrayCreationExpr).getInit().getInit(getVarargsCount() - 1)
      else result = last
    )
  }

  /** Holds if this uses the "logger ({})" format syntax and the last argument is a `Throwable`. */
  predicate hasTrailingThrowableArgument() {
    getSyntax() = TFmtLogger() and
    getLastArg().getType().(RefType).getASourceSupertype*() instanceof TypeThrowable
  }

  /** Gets the argument to this call in the position of the format string */
  Expr getFormatArgument() { result = getArgumentOrQualifier(this, this.getFormatStringIndex()) }

  /** Gets an argument to be formatted. */
  Expr getAnArgumentToBeFormatted() {
    exists(int i |
      result = this.getArgument(i) and
      i > this.getFormatStringIndex() and
      not hasExplicitVarargsArray()
    )
  }

  /** Holds if the varargs argument is given as an explicit array. */
  private predicate hasExplicitVarargsArray() {
    this.getNumArgument() = this.getFormatStringIndex() + 2 and
    this.getArgument(1 + this.getFormatStringIndex()).getType() instanceof Array
  }

  /** Gets the length of the varargs array if it can determined. */
  int getVarargsCount() {
    if this.hasExplicitVarargsArray()
    then
      exists(Expr arg | arg = this.getArgument(1 + this.getFormatStringIndex()) |
        result = arg.(ArrayCreationExpr).getFirstDimensionSize() or
        result =
          arg
              .(VarAccess)
              .getVariable()
              .getAnAssignedValue()
              .(ArrayCreationExpr)
              .getFirstDimensionSize()
      )
    else result = this.getNumArgument() - this.getFormatStringIndex() - 1
  }

  /** Gets a `FormatString` that is used by this call. */
  FormatString getAFormatString() { result.getAFormattingUse() = this }
}

/** Holds if `m` calls `toString()` on its `i`th argument. */
private predicate printMethod(Method m, int i) {
  exists(RefType t |
    t = m.getDeclaringType() and
    m.getParameterType(i) instanceof TypeObject
  |
    (t.hasQualifiedName("java.io", "PrintWriter") or t.hasQualifiedName("java.io", "PrintStream")) and
    (m.hasName("print") or m.hasName("println"))
    or
    (
      t.hasQualifiedName("java.lang", "StringBuilder") or
      t.hasQualifiedName("java.lang", "StringBuffer")
    ) and
    (m.hasName("append") or m.hasName("insert"))
    or
    t instanceof TypeString and m.hasName("valueOf")
  )
}

/**
 * Holds if `e` occurs in a position where it may be converted to a string by
 * an implicit call to `toString()`.
 */
predicate implicitToStringCall(Expr e) {
  not e.getType() instanceof TypeString and
  (
    exists(FormattingCall fmtcall | fmtcall.getAnArgumentToBeFormatted() = e)
    or
    exists(AddExpr add | add.getType() instanceof TypeString and add.getAnOperand() = e)
    or
    exists(MethodAccess ma, Method m, int i |
      ma.getMethod() = m and
      ma.getArgument(i) = e and
      printMethod(m, i)
    )
  )
}

/**
 * A call to a `format` or `printf` method.
 */
class StringFormat extends MethodAccess, FormattingCall {
  StringFormat() { this.getCallee() instanceof StringFormatMethod }
}

/**
 * Holds if `fmt` is used as part of a format string.
 */
private predicate formatStringFragment(Expr fmt) {
  any(FormattingCall call).getFormatArgument() = fmt
  or
  exists(Expr e | formatStringFragment(e) |
    e.(VarAccess).getVariable().getAnAssignedValue() = fmt or
    e.(AddExpr).getLeftOperand() = fmt or
    e.(AddExpr).getRightOperand() = fmt or
    e.(ChooseExpr).getAResultExpr() = fmt
  )
}

/**
 * Holds if `e` is a part of a format string with the approximate value
 * `fmtvalue`. The value is approximated by ignoring details that are
 * irrelevant for determining the number of format specifiers in the resulting
 * string.
 */
private predicate formatStringValue(Expr e, string fmtvalue) {
  formatStringFragment(e) and
  (
    e.(StringLiteral).getRepresentedString() = fmtvalue
    or
    e.getType() instanceof IntegralType and fmtvalue = "1" // dummy value
    or
    e.getType() instanceof BooleanType and fmtvalue = "x" // dummy value
    or
    e.getType() instanceof EnumType and fmtvalue = "x" // dummy value
    or
    exists(Variable v |
      e = v.getAnAccess() and
      v.isFinal() and
      v.getType() instanceof TypeString and
      formatStringValue(v.getInitializer(), fmtvalue)
    )
    or
    exists(LocalVariableDecl v |
      e = v.getAnAccess() and
      not exists(AssignAddExpr aa | aa.getDest() = v.getAnAccess()) and
      1 = count(v.getAnAssignedValue()) and
      v.getType() instanceof TypeString and
      formatStringValue(v.getAnAssignedValue(), fmtvalue)
    )
    or
    exists(AddExpr add, string left, string right |
      add = e and
      add.getType() instanceof TypeString and
      formatStringValue(add.getLeftOperand(), left) and
      formatStringValue(add.getRightOperand(), right) and
      fmtvalue = left + right
    )
    or
    formatStringValue(e.(ChooseExpr).getAResultExpr(), fmtvalue)
    or
    exists(Method getprop, MethodAccess ma, string prop |
      e = ma and
      ma.getMethod() = getprop and
      getprop.hasName("getProperty") and
      getprop.getDeclaringType().hasQualifiedName("java.lang", "System") and
      getprop.getNumberOfParameters() = 1 and
      ma.getAnArgument().(StringLiteral).getRepresentedString() = prop and
      (prop = "line.separator" or prop = "file.separator" or prop = "path.separator") and
      fmtvalue = "x" // dummy value
    )
    or
    exists(Field f |
      e = f.getAnAccess() and
      f.getDeclaringType().hasQualifiedName("java.io", "File") and
      fmtvalue = "x" // dummy value
    |
      f.hasName("pathSeparator") or
      f.hasName("pathSeparatorChar") or
      f.hasName("separator") or
      f.hasName("separatorChar")
    )
  )
}

/**
 * A string that is used as the format string in a `FormattingCall`.
 */
class FormatString extends string {
  FormatString() { formatStringValue(_, this) }

  /** Gets a `FormattingCall` that uses this as its format string. */
  FormattingCall getAFormattingUse() {
    exists(Expr fmt | formatStringValue(fmt, this) |
      result.getFormatArgument() = fmt
      or
      exists(VariableAssign va |
        defUsePair(va, result.getFormatArgument()) and va.getSource() = fmt
      )
      or
      result.getFormatArgument().(FieldAccess).getField().getAnAssignedValue() = fmt
    )
  }

  /**
   * Gets the largest argument index (1-indexed) that is referred by a format
   * specifier. Gets the value 0 if there are no format specifiers.
   */
  /*abstract*/ int getMaxFmtSpecIndex() { none() }

  /**
   * Gets an argument index (1-indexed) less than `getMaxFmtSpecIndex()` that
   * is not referred by any format specifier.
   */
  /*abstract*/ int getASkippedFmtSpecIndex() { none() }
}

private class PrintfFormatString extends FormatString {
  PrintfFormatString() { this.getAFormattingUse().getSyntax() = TFmtPrintf() }

  /**
   * Gets a boolean value that indicates whether the `%` character at index `i`
   * is an escaped percentage sign or a format specifier.
   */
  private boolean isEscapedPct(int i) {
    this.charAt(i) = "%" and
    if this.charAt(i - 1) = "%"
    then result = this.isEscapedPct(i - 1).booleanNot()
    else result = false
  }

  /** Holds if the format specifier at index `i` is a reference to an argument. */
  private predicate fmtSpecIsRef(int i) {
    false = this.isEscapedPct(i) and
    this.charAt(i) = "%" and
    exists(string c |
      c = this.charAt(i + 1) and
      c != "%" and
      c != "n"
    )
  }

  /**
   * Holds if the format specifier at index `i` refers to the same argument as
   * the preceding format specifier.
   */
  private predicate fmtSpecRefersToPrevious(int i) {
    this.fmtSpecIsRef(i) and
    "<" = this.charAt(i + 1)
  }

  /**
   * Gets the index of the specific argument (1-indexed) that the format
   * specifier at index `i` refers to, if any.
   */
  private int fmtSpecRefersToSpecificIndex(int i) {
    this.fmtSpecIsRef(i) and
    exists(string num | result = num.toInt() |
      num = this.charAt(i + 1) and "$" = this.charAt(i + 2)
      or
      num = this.charAt(i + 1) + this.charAt(i + 2) and "$" = this.charAt(i + 3)
    )
  }

  /**
   * Holds if the format specifier at index `i` refers to the next argument in
   * sequential order.
   */
  private predicate fmtSpecRefersToSequentialIndex(int i) {
    this.fmtSpecIsRef(i) and
    not exists(this.fmtSpecRefersToSpecificIndex(i)) and
    not this.fmtSpecRefersToPrevious(i)
  }

  override int getMaxFmtSpecIndex() {
    result =
      max(int ix |
        ix = fmtSpecRefersToSpecificIndex(_) or
        ix = count(int i | fmtSpecRefersToSequentialIndex(i))
      )
  }

  override int getASkippedFmtSpecIndex() {
    result in [1 .. getMaxFmtSpecIndex()] and
    result > count(int i | fmtSpecRefersToSequentialIndex(i)) and
    not result = fmtSpecRefersToSpecificIndex(_)
  }
}

private class LoggerFormatString extends FormatString {
  LoggerFormatString() { this.getAFormattingUse().getSyntax() = TFmtLogger() }

  /**
   * Gets a boolean value that indicates whether the `\` character at index `i`
   * is an unescaped backslash.
   */
  private boolean isUnescapedBackslash(int i) {
    this.charAt(i) = "\\" and
    if this.charAt(i - 1) = "\\"
    then result = this.isUnescapedBackslash(i - 1).booleanNot()
    else result = true
  }

  /** Holds if an unescaped placeholder `{}` occurs at index `i`. */
  private predicate fmtPlaceholder(int i) {
    this.charAt(i) = "{" and
    this.charAt(i + 1) = "}" and
    not true = isUnescapedBackslash(i - 1)
  }

  override int getMaxFmtSpecIndex() { result = count(int i | fmtPlaceholder(i)) }
}
