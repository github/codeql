/**
 * Classes pertaining to test cases themselves.
 */

import java
private import semmle.code.java.dataflow.internal.DataFlowUtil
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSummary
private import semmle.code.java.dataflow.internal.FlowSummaryImpl
private import FlowTestCaseUtils
private import FlowTestCaseSupportMethods

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
 * Returns type of parameter `i` of `callable`, including the type of `this` for parameter -1.
 */
Type getParameterType(CallableToTest callable, int i) {
  if i = -1 then result = callable.getDeclaringType() else result = callable.getParameterType(i)
}

private class CallableToTest extends Callable {
  CallableToTest() {
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext
    |
      summaryModel(namespace, type, subtypes, name, signature, ext, _, _, _, _) and
      this = interpretElement(namespace, type, subtypes, name, signature, ext) and
      this.isPublic() and
      getRootType(this.getDeclaringType()).(RefType).isPublic()
    )
  }
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
      summaryModel(namespace, type, subtypes, name, signature, ext, inputSpec, outputSpec, kind,
        false, row) and
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
    else
      if baseOutput = SummaryComponentStack::argument(i)
      then result = "out"
      else
        if i = -1
        then result = "instance"
        else result = this.getFiller(i)
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
    // or
    // in.method(filler, out, filler);
    // or
    // out.method(filler, in, filler);
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
    kind = "value" and result = "// $ hasValueFlow"
    or
    kind = "taint" and result = "// $ hasTaintFlow"
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
   * Returns a call to `source()` wrapped in `newWith` methods as needed according to `input`.
   * For example, if the input specification is `ArrayElement of MapValue of Argument[0]`, this
   * will return `newWithMapValue(newWithArrayElement(source()))`.
   */
  string getInput(SummaryComponentStack stack) {
    stack = input and result = "source()"
    or
    exists(SummaryComponentStack s | s.tail() = stack |
      // we currently only know the type if the stack is one level in
      if stack = baseInput
      then result = SupportMethod::genMethodFor(this.getInputType(), s).getCall(this.getInput(s))
      else result = SupportMethod::genMethodForContent(s).getCall(this.getInput(s))
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
        if componentStack.tail() = baseOutput
        then
          result =
            SupportMethod::getMethodFor(this.getOutputType(), componentStack)
                .getCall(this.getOutput(componentStack.tail()))
        else
          result =
            SupportMethod::getMethodForContent(componentStack)
                .getCall(this.getOutput(componentStack.tail()))
    )
  }

  /**
   * Returns the definition of a `newWith` method needed to set up the input or a `get` method needed to set up the output for this test.
   */
  SupportMethod getASupportMethod() {
    exists(SummaryComponentStack s | s = input.drop(_) and s.tail() != baseInput |
      result = SupportMethod::genMethodForContent(s)
    )
    or
    exists(SummaryComponentStack s | s = input.drop(_) and s.tail() = baseInput |
      result = SupportMethod::genMethodFor(this.getInputType(), s)
    )
    or
    result = SupportMethod::getMethodFor(this.getOutputType(), output)
    or
    result = SupportMethod::getMethodForContent(output.tail().drop(_))
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
        ")" + this.getInput(baseInput) + ";\n\t\t\t" + this.getInstancePrefix() + this.makeCall() +
        ";\n\t\t\t" + "sink(" + this.getOutput(output) + "); " + this.getExpectation() + "\n\t\t}\n"
  }
}
