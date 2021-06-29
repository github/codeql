/**
 * Test-case generator for flow summaries. See the accompanying `GenerateFlowTestCase.py` for full
 * documentation and usage information.
 */

import java
private import semmle.code.java.dataflow.internal.DataFlowUtil
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSummary
private import semmle.code.java.dataflow.internal.FlowSummaryImpl

/**
 * A CSV row to generate tests for. Users should extend this to define which
 * tests to generate. Rows specified here should also satisfy `SummaryModelCsv.row`.
 */
class TargetSummaryModelCsv extends Unit {
  /**
   * Holds if a test should be generated for `row`.
   */
  abstract predicate row(string r);
}

/**
 * Gets a CSV row for which a test has been requested, but `SummaryModelCsv.row` does not hold of it.
 */
query string missingSummaryModelCsv() {
  any(TargetSummaryModelCsv target).row(result) and
  not any(SummaryModelCsv model).row(result)
}

/**
 * Gets a CSV row for which a test has been requested, and `SummaryModelCsv.row` does hold, but
 * nonetheless we can't generate a test case for it, indicating we cannot resolve either the callable
 * spec or an input or output spec.
 */
query string getAParseFailure(string reason) {
  any(TargetSummaryModelCsv target).row(result) and
  any(SummaryModelCsv model).row(result) and
  (
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext
    |
      summaryModel(namespace, type, subtypes, name, signature, ext, _, _, _, result) and
      not exists(interpretElement(namespace, type, subtypes, name, signature, ext)) and
      reason = "callable could not be resolved"
    )
    or
    exists(string inputSpec |
      summaryModel(_, _, _, _, _, _, inputSpec, _, _, result) and
      not Private::External::interpretSpec(inputSpec, _) and
      reason = "input spec could not be parsed"
    )
    or
    exists(string outputSpec |
      summaryModel(_, _, _, _, _, _, _, outputSpec, _, result) and
      not Private::External::interpretSpec(outputSpec, _) and
      reason = "output spec could not be parsed"
    )
  )
}

private class CallableToTest extends Callable {
  CallableToTest() {
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext
    |
      summaryModel(namespace, type, subtypes, name, signature, ext, _, _, _) and
      this = interpretElement(namespace, type, subtypes, name, signature, ext)
    )
  }
}

/**
 * Returns type of parameter `i` of `callable`, including the type of `this` for parameter -1.
 */
Type getParameterType(CallableToTest callable, int i) {
  if i = -1 then result = callable.getDeclaringType() else result = callable.getParameterType(i)
}

/**
 * Returns a zero value of primitive type `t`.
 */
string getZero(PrimitiveType t) {
  t.hasName("float") and result = "0.0f"
  or
  t.hasName("double") and result = "0.0"
  or
  t.hasName("int") and result = "0"
  or
  t.hasName("boolean") and result = "false"
  or
  t.hasName("short") and result = "(short)0"
  or
  t.hasName("byte") and result = "(byte)0"
  or
  t.hasName("char") and result = "'a'"
  or
  t.hasName("long") and result = "0L"
}

/**
 * Holds if `c` may require disambiguation from an overload with the same argument count.
 */
predicate mayBeAmbiguous(Callable c) {
  exists(Callable other, string package, string type, string name |
    c.hasQualifiedName(package, type, name) and
    other.hasQualifiedName(package, type, name) and
    other.getNumberOfParameters() = c.getNumberOfParameters() and
    other != c
  )
}

/**
 * Returns the `content` wrapped by `component`, if any.
 */
Content getContent(SummaryComponent component) { component = SummaryComponent::content(result) }

/**
 * Returns a valid Java token naming the field `fc`.
 */
string getFieldToken(FieldContent fc) {
  result =
    fc.getField().getDeclaringType().getSourceDeclaration().getName() + "_" +
      fc.getField().getName()
}

/**
 * Returns a token suitable for incorporation into a Java method name describing content `c`.
 */
string contentToken(Content c) {
  c instanceof ArrayContent and result = "ArrayElement"
  or
  c instanceof CollectionContent and result = "Element"
  or
  c instanceof MapKeyContent and result = "MapKey"
  or
  c instanceof MapValueContent and result = "MapValue"
  or
  result = getFieldToken(c)
}

/**
 * Returns the outermost type enclosing type `t` (which may be `t` itself).
 */
RefType getRootType(RefType t) {
  if t instanceof NestedType
  then result = getRootType(t.(NestedType).getEnclosingType())
  else result = t
}

/**
 * Returns `t`'s first upper bound if `t` is a type variable; otherwise returns `t`.
 */
RefType replaceTypeVariable(RefType t) {
  if t instanceof TypeVariable
  then result = replaceTypeVariable(t.(TypeVariable).getFirstUpperBoundType())
  else result = t
}

/**
 * Returns `t`'s outermost enclosing type, in raw form (i.e. generic types are given without generic parameters, and type variables are replaced by their bounds).
 */
Type getRootSourceDeclaration(Type t) {
  if t instanceof RefType
  then result = getRootType(replaceTypeVariable(t)).getSourceDeclaration()
  else result = t
}

/**
 * A test snippet (a fragment of Java code that checks that `row` causes `callable` to propagate value/taint (according to `preservesValue`)
 * from `input` to `output`). Usually there is one of these per CSV row (`row`), but there may be more if `row` describes more than one
 * override or overload of a particular method, or if the input or output specifications cover more than one argument.
 */
private newtype TTestCase =
  MkTestCase(
    CallableToTest callable, SummaryComponentStack input, SummaryComponentStack output, string kind,
    string row
  ) {
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext,
      string inputSpec, string outputSpec
    |
      any(TargetSummaryModelCsv tsmc).row(row) and
      summaryModel(namespace, type, subtypes, name, signature, ext, inputSpec, outputSpec, kind, row) and
      callable = interpretElement(namespace, type, subtypes, name, signature, ext) and
      Private::External::interpretSpec(inputSpec, input) and
      Private::External::interpretSpec(outputSpec, output)
    )
  }

/**
 * A test snippet (as `TTestCase`, except `baseInput` and `baseOutput` hold the bottom of the summary stacks
 * `input` and `output` respectively (hence, `baseInput` and `baseOutput` are parameters or return values).
 */
class TestCase extends TTestCase {
  CallableToTest callable;
  SummaryComponentStack input;
  SummaryComponentStack output;
  SummaryComponentStack baseInput;
  SummaryComponentStack baseOutput;
  string kind;
  string row;

  TestCase() {
    this = MkTestCase(callable, input, output, kind, row) and
    baseInput = input.drop(input.length() - 1) and
    baseOutput = output.drop(output.length() - 1)
  }

  /**
   * Returns a representation of this test case's parameters suitable for debugging.
   */
  string toString() {
    result =
      row + " / " + callable + " / " + input + " / " + output + " / " + baseInput + " / " +
        baseOutput + " / " + kind
  }

  /**
   * Returns a value to pass as `callable`'s `argIdx`th argument whose value is irrelevant to the test
   * being generated. This will be a zero or a null value, perhaps typecast if we need to disambiguate overloads.
   */
  string getFiller(int argIdx) {
    exists(Type t | t = callable.getParameterType(argIdx) |
      t instanceof RefType and
      (
        if mayBeAmbiguous(callable)
        then result = "(" + getShortNameIfPossible(t) + ")null"
        else result = "null"
      )
      or
      result = getZero(t)
    )
  }

  /**
   * Returns the value to pass for `callable`'s `i`th argument, which may be `in` if this is the input argument for
   * this test, `out` if it is the output, `instance` if this is an instance method and the instance is neither the
   * input nor the output, or a zero/null filler value otherwise.
   */
  string getArgument(int i) {
    (i = -1 or exists(callable.getParameter(i))) and
    if baseInput = SummaryComponentStack::argument(i)
    then result = "in"
    else (
      if baseOutput = SummaryComponentStack::argument(i)
      then result = "out"
      else (
        if i = -1 then result = "instance" else result = this.getFiller(i)
      )
    )
  }

  /**
   * Returns a statement invoking `callable`, passing `input` and capturing `output` as needed.
   */
  string makeCall() {
    // For example, one of:
    // out = in.method(filler);
    // or
    // out = filler.method(filler, in, filler);
    // or
    // out = Type.method(filler, in, filler);
    // or
    // filler.method(filler, in, out, filler);
    // or
    // Type.method(filler, in, out, filler);
    // or
    // out = new Type(filler, in, filler);
    // or
    // new Type(filler, in, out, filler);
    exists(string storePrefix, string invokePrefix, string args |
      (
        if
          baseOutput = SummaryComponentStack::return()
          or
          callable instanceof Constructor and baseOutput = SummaryComponentStack::argument(-1)
        then storePrefix = "out = "
        else storePrefix = ""
      ) and
      (
        if callable instanceof Constructor
        then invokePrefix = "new "
        else
          if callable.(Method).isStatic()
          then invokePrefix = getShortNameIfPossible(callable.getDeclaringType()) + "."
          else invokePrefix = this.getArgument(-1) + "."
      ) and
      args = concat(int i | i >= 0 | this.getArgument(i), ", " order by i) and
      result = storePrefix + invokePrefix + callable.getName() + "(" + args + ")"
    )
  }

  /**
   * Returns an inline test expectation appropriate to this CSV row.
   */
  string getExpectation() {
    kind = "value" and result = "// $hasValueFlow"
    or
    kind = "taint" and result = "// $hasTaintFlow"
  }

  /**
   * Returns a declaration and initialisation of a variable named `instance` if required; otherwise returns an empty string.
   */
  string getInstancePrefix() {
    if
      callable instanceof Method and
      not callable.(Method).isStatic() and
      baseOutput != SummaryComponentStack::argument(-1) and
      baseInput != SummaryComponentStack::argument(-1)
    then
      // In this case `out` is the instance.
      result = getShortNameIfPossible(callable.getDeclaringType()) + " instance = null;\n\t\t\t"
    else result = ""
  }

  /**
   * Returns the type of the output for this test.
   */
  Type getOutputType() {
    if baseOutput = SummaryComponentStack::return()
    then result = callable.getReturnType()
    else
      exists(int i |
        baseOutput = SummaryComponentStack::argument(i) and
        result = getParameterType(callable, i)
      )
  }

  /**
   * Returns the type of the input for this test.
   */
  Type getInputType() {
    exists(int i |
      baseInput = SummaryComponentStack::argument(i) and
      result = getParameterType(callable, i)
    )
  }

  /**
   * Returns the Java name for the type of the input to this test.
   */
  string getInputTypeString() { result = getShortNameIfPossible(this.getInputType()) }

  /**
   * Returns the next-highest stack item in `input`, treating the list as circular, so
   * the top item's successor is `baseInput`, the bottom of the stack.
   */
  SummaryComponentStack nextInput(SummaryComponentStack prev) {
    exists(SummaryComponentStack next | next.tail() = prev and next = input.drop(_) | result = next)
    or
    not exists(SummaryComponentStack next | next.tail() = prev and next = input.drop(_)) and
    result = baseInput
  }

  /**
   * Returns a call to `source()` wrapped in `newWith` methods as needed according to `input`.
   * For example, if the input specification is `ArrayElement of MapValue of Argument[0]`, this
   * will return `newWithMapValue(newWithArrayElement(source()))`.
   *
   * This requires a slightly awkward walk, out from the element above the root (`Argument[0]` above)
   * climbing up towards the outer `ArrayElement of...`. This is implemented by treating the stack as
   * a circular list, walking it backwards and treating the root as a sentinel indicating we should
   * emit `source()`.
   */
  string getInput(SummaryComponentStack componentStack) {
    componentStack = input.drop(_) and
    (
      if componentStack = baseInput
      then result = "source()"
      else
        result =
          "newWith" + contentToken(getContent(componentStack.head())) + "(" +
            this.getInput(nextInput(componentStack)) + ")"
    )
  }

  /**
   * Returns `out` wrapped in `get` methods as needed according to `output`.
   * For example, if the output specification is `ArrayElement of MapValue of Argument[0]`, this
   * will return `getArrayElement(getMapValue(out))`.
   */
  string getOutput(SummaryComponentStack componentStack) {
    componentStack = output.drop(_) and
    (
      if componentStack = baseOutput
      then result = "out"
      else
        result =
          "get" + contentToken(getContent(componentStack.head())) + "(" +
            this.getOutput(componentStack.tail()) + ")"
    )
  }

  /**
   * Returns the definition of a `newWith` method needed to set up the input or a `get` method needed to set up the output for this test.
   */
  string getASupportMethod() {
    result =
      "Object newWith" + contentToken(getContent(input.drop(_).head())) +
        "(Object element) { return null; }" or
    result =
      "Object get" + contentToken(getContent(output.drop(_).head())) +
        "(Object container) { return null; }"
  }

  /**
   * Gets a string that specifies summary component `c` in a summary specification CSV row.
   */
  string getComponentSpec(SummaryComponent c) {
    exists(Content content |
      c = SummaryComponent::content(content) and
      (
        content instanceof ArrayContent and result = "ArrayElement"
        or
        content instanceof MapValueContent and result = "MapValue"
        or
        content instanceof MapKeyContent and result = "MapKey"
        or
        content instanceof CollectionContent and result = "Element"
        or
        result = "Field[" + content.(FieldContent).getField().getQualifiedName() + "]"
      )
    )
  }

  /**
   * Returns a CSV row describing a support method (`newWith` or `get` method) needed to set up the output for this test.
   *
   * For example, `newWithMapValue` will propagate a value from `Argument[0]` to `MapValue of ReturnValue`, and `getMapValue`
   * will do the opposite.
   */
  string getASupportMethodModel() {
    exists(SummaryComponent c, string contentCsvDescription |
      c = input.drop(_).head() and contentCsvDescription = getComponentSpec(c)
    |
      result =
        "generatedtest;Test;false;newWith" + contentToken(getContent(c)) + ";;;Argument[0];" +
          contentCsvDescription + " of ReturnValue;value"
    )
    or
    exists(SummaryComponent c, string contentCsvDescription |
      c = output.drop(_).head() and contentCsvDescription = getComponentSpec(c)
    |
      result =
        "generatedtest;Test;false;get" + contentToken(getContent(c)) + ";;;" + contentCsvDescription
          + " of Argument[0];ReturnValue;value"
    )
  }

  /**
   * Gets an outer class name that this test would ideally import (and will, unless it clashes with another
   * type of the same name).
   */
  Type getADesiredImport() {
    result =
      getRootSourceDeclaration([
          this.getOutputType(), this.getInputType(), callable.getDeclaringType()
        ])
    or
    // Will refer to parameter types in disambiguating casts, like `(String)null`
    mayBeAmbiguous(callable) and result = getRootSourceDeclaration(callable.getAParamType())
  }

  /**
   * Gets a test snippet (test body fragment) testing this `callable` propagates value or taint from
   * `input` to `output`, as specified by `row_` (which necessarily equals `row`).
   */
  string getATestSnippetForRow(string row_) {
    row_ = row and
    result =
      "\t\t{\n\t\t\t// \"" + row + "\"\n\t\t\t" + getShortNameIfPossible(this.getOutputType()) +
        " out = null;\n\t\t\t" + this.getInputTypeString() + " in = (" + this.getInputTypeString() +
        ")" + this.getInput(this.nextInput(baseInput)) + ";\n\t\t\t" + this.getInstancePrefix() +
        this.makeCall() + ";\n\t\t\t" + "sink(" + this.getOutput(output) + "); " +
        this.getExpectation() + "\n\t\t}\n"
  }
}

/**
 * Holds if type `t` does not clash with another type we want to import that has the same base name.
 */
predicate isImportable(Type t) {
  t = any(TestCase tc).getADesiredImport() and
  t =
    unique(Type sharesBaseName |
      sharesBaseName = any(TestCase tc).getADesiredImport() and
      sharesBaseName.getName() = t.getName()
    |
      sharesBaseName
    )
}

/**
 * Returns a printable name for type `t`, stripped of generics and, if a type variable,
 * replaced by its bound. Usually this is a short name, but it may be package-qualified
 * if we cannot import it due to a name clash.
 */
string getShortNameIfPossible(Type t) {
  getRootSourceDeclaration(t) = any(TestCase tc).getADesiredImport() and
  if t instanceof RefType
  then
    exists(RefType replaced, string nestedName |
      replaced = replaceTypeVariable(t).getSourceDeclaration() and
      nestedName = replaced.nestedName().replaceAll("$", ".")
    |
      if isImportable(getRootSourceDeclaration(t))
      then result = nestedName
      else result = replaced.getPackage().getName() + "." + nestedName
    )
  else result = t.getName()
}

/**
 * Returns an import statement to include in the test case header.
 */
string getAnImportStatement() {
  exists(RefType t |
    t = any(TestCase tc).getADesiredImport() and
    isImportable(t) and
    t.getPackage().getName() != "java.lang"
  |
    result = "import " + t.getPackage().getName() + "." + t.getName() + ";"
  )
}

/**
 * Returns a support method to include in the generated test class.
 */
string getASupportMethod() {
  result = "Object source() { return null; }" or
  result = "void sink(Object o) { }" or
  result = any(TestCase tc).getASupportMethod()
}

/**
 * Returns a CSV specification of the taint-/value-propagation behaviour of a test support method (`get` or `newWith` method).
 */
query string getASupportMethodModel() { result = any(TestCase tc).getASupportMethodModel() }

/**
 * Gets a Java file body testing all requested CSV rows against whatever classes and methods they resolve against.
 */
query string getTestCase() {
  result =
    "package generatedtest;\n\n" + concat(getAnImportStatement() + "\n") +
      "\n// Test case generated by GenerateFlowTestCase.ql\npublic class Test {\n\n" +
      concat("\t" + getASupportMethod() + "\n") + "\n\tpublic void test() {\n\n" +
      concat(string row, string snippet |
        snippet = any(TestCase tc).getATestSnippetForRow(row)
      |
        snippet order by row
      ) + "\n\t}\n\n}"
}
