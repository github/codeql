import java
import semmle.code.java.dataflow.internal.DataFlowPrivate
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.FlowSummary
import semmle.code.java.dataflow.internal.FlowSummaryImpl

bindingset[this]
abstract class CsvRow extends string { }

Type getParameterType(Private::External::SummarizedCallableExternal callable, int i) {
  if i = -1 then result = callable.getDeclaringType() else result = callable.getParameterType(i)
}

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

predicate mayBeAmbiguous(Callable c) {
  exists(Callable other, string package, string type, string name |
    c.hasQualifiedName(package, type, name) and
    other.hasQualifiedName(package, type, name) and
    other.getNumberOfParameters() = c.getNumberOfParameters() and
    other != c
  )
}

Content getContent(SummaryComponent component) { component = SummaryComponent::content(result) }

string getFieldToken(FieldContent fc) {
  result =
    fc.getField().getDeclaringType().getSourceDeclaration().getName() + "_" +
      fc.getField().getName()
}

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

RefType getRootType(RefType t) {
  if t instanceof NestedType
  then result = getRootType(t.(NestedType).getEnclosingType())
  else result = t
}

RefType replaceTypeVariable(RefType t) {
  if t instanceof TypeVariable
  then result = t.(TypeVariable).getFirstUpperBoundType()
  else result = t
}

Type getRootSourceDeclaration(Type t) {
  if t instanceof RefType
  then result = getRootType(replaceTypeVariable(t)).getSourceDeclaration()
  else result = t
}

newtype TRowTestSnippet =
  MkSnippet(
    CsvRow row, Private::External::SummarizedCallableExternal callable, SummaryComponentStack input,
    SummaryComponentStack output, boolean preservesValue
  ) {
    callable.propagatesFlowForRow(input, output, preservesValue, row)
  }

class RowTestSnippet extends TRowTestSnippet {
  string row;
  Private::External::SummarizedCallableExternal callable;
  SummaryComponentStack input;
  SummaryComponentStack output;
  SummaryComponentStack baseInput;
  SummaryComponentStack baseOutput;
  boolean preservesValue;

  RowTestSnippet() {
    this = MkSnippet(row, callable, input, output, preservesValue) and
    baseInput = input.drop(input.length() - 1) and
    baseOutput = output.drop(output.length() - 1)
  }

  string toString() {
    result =
      row + " / " + callable + " / " + input + " / " + output + " / " + baseInput + " / " +
        baseOutput + " / " + preservesValue
  }

  string getFiller(int argIdx) {
    exists(Type t | t = callable.getParameterType(argIdx) |
      t instanceof RefType and
      (
        if mayBeAmbiguous(callable)
        then result = "(" + getShortNameIfPossible(t.(RefType).getSourceDeclaration()) + ")null"
        else result = "null"
      )
      or
      result = getZero(t)
    )
  }

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

  string makeCall() {
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
          then
            invokePrefix =
              getShortNameIfPossible(callable.getDeclaringType().getSourceDeclaration()) + "."
          else invokePrefix = this.getArgument(-1) + "."
      ) and
      args = concat(int i | i >= 0 | this.getArgument(i), ", " order by i) and
      result = storePrefix + invokePrefix + callable.getName() + "(" + args + ")"
    )
  }

  string getExpectation() {
    preservesValue = true and result = "// $hasValueFlow"
    or
    preservesValue = false and result = "// $hasTaintFlow"
  }

  string getInstancePrefix() {
    if
      callable instanceof Method and
      not callable.(Method).isStatic() and
      baseOutput != SummaryComponentStack::argument(-1) and
      baseInput != SummaryComponentStack::argument(-1)
    then
      // In this case `out` is the instance.
      result = getShortNameIfPossible(callable.getDeclaringType()) + " instance = null;\n"
    else result = ""
  }

  Type getOutputType() {
    if baseOutput = SummaryComponentStack::return()
    then result = callable.getReturnType()
    else
      exists(int i |
        baseOutput = SummaryComponentStack::argument(i) and
        result = getParameterType(callable, i)
      )
  }

  Type getInputType() {
    exists(int i |
      baseInput = SummaryComponentStack::argument(i) and
      result = getParameterType(callable, i)
    )
  }

  string getInputTypeString() { result = getShortNameIfPossible(this.getInputType()) }

  string getInput(SummaryComponentStack componentStack) {
    componentStack = input.drop(_) and
    (
      if componentStack = baseInput
      then result = "source()"
      else
        result =
          "newWith" + contentToken(getContent(componentStack.head())) + "(" +
            this.getInput(componentStack.tail()) + ")"
    )
  }

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

  string getASupportMethod() {
    result =
      "Object newWith" + contentToken(getContent(input.drop(_).head())) +
        "(Object element) { return null; }" or
    result =
      "Object get" + contentToken(getContent(output.drop(_).head())) +
        "(Object container) { return null; }"
  }

  string getASupportMethodModel() {
    exists(SummaryComponent c, string contentSsvDescription |
      c = input.drop(_).head() and c = Private::External::interpretComponent(contentSsvDescription)
    |
      result =
        "generatedtest;Test;false;newWith" + contentToken(getContent(c)) + ";;;Argument[0];" +
          contentSsvDescription + " of ReturnValue;value"
    )
    or
    exists(SummaryComponent c, string contentSsvDescription |
      c = output.drop(_).head() and c = Private::External::interpretComponent(contentSsvDescription)
    |
      result =
        "generatedtest;Test;false;get" + contentToken(getContent(c)) + ";;;" + contentSsvDescription
          + " of Argument[0];ReturnValue;value"
    )
  }

  Type getADesiredImport() {
    result =
      getRootSourceDeclaration([
          this.getOutputType(), this.getInputType(), callable.getDeclaringType()
        ])
    or
    // Will refer to parameter types in disambiguating casts, like `(String)null`
    mayBeAmbiguous(callable) and result = getRootSourceDeclaration(callable.getAParamType())
  }

  string getATestSnippetForRow(string row_) {
    row_ = row and
    result =
      "\t\t{\n\t\t\t// \"" + row + "\"\n\t\t\t" + getShortNameIfPossible(this.getOutputType()) +
        " out = null;\n\t\t\t" + this.getInputTypeString() + " in = (" + this.getInputTypeString() +
        ")" + this.getInput(input) + ";\n\t\t\t" + this.getInstancePrefix() + this.makeCall() +
        ";\n\t\t\t" + "sink(" + this.getOutput(output) + "); " + this.getExpectation() + "\n\t\t}\n"
  }
}

predicate isImportable(Type t) {
  t = any(RowTestSnippet r).getADesiredImport() and
  t =
    unique(Type sharesBaseName |
      sharesBaseName = any(RowTestSnippet r).getADesiredImport() and
      sharesBaseName.getName() = t.getName()
    |
      sharesBaseName
    )
}

string getShortNameIfPossible(Type t) {
  getRootSourceDeclaration(t) = any(RowTestSnippet r).getADesiredImport() and
  if t instanceof RefType
  then
    exists(RefType replaced, string nestedName |
      replaced = replaceTypeVariable(t) and
      nestedName = replaced.nestedName().replaceAll("$", ".")
    |
      if isImportable(getRootSourceDeclaration(t))
      then result = nestedName
      else result = replaced.getPackage().getName() + "." + nestedName
    )
  else result = t.getName()
}

string getAnImportStatement() {
  exists(RefType t |
    t = any(RowTestSnippet r).getADesiredImport() and
    isImportable(t) and
    t.getPackage().getName() != "java.lang"
  |
    result = "import " + t.getPackage().getName() + "." + t.getName() + ";"
  )
}

string getASupportMethod() {
  result = "Object source() { return null; }" or
  result = "void sink(Object o) { }" or
  result = any(RowTestSnippet r).getASupportMethod()
}

query string getASupportMethodModel() { result = any(RowTestSnippet r).getASupportMethodModel() }

query string getTestCase() {
  result =
    "package generatedtest;\n\n" + concat(getAnImportStatement() + "\n") +
      "\n//Test case generated by GenerateFlowTestCase.ql\npublic class Test {\n\n" +
      concat("\t" + getASupportMethod() + "\n") + "\n\tpublic void test() {\n\n" +
      concat(string row, string snippet |
        snippet = any(RowTestSnippet r).getATestSnippetForRow(row)
      |
        snippet order by row
      ) + "\n\t}\n\n}"
}
