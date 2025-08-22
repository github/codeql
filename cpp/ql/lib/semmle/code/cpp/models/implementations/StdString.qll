/**
 * Provides implementation classes modeling `std::string` (and other
 * instantiations of `std::basic_string`) and `std::ostream`. See
 * `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.interfaces.Iterator
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.Alias

/**
 * The `std::basic_string` template class instantiations.
 */
private class StdBasicString extends ClassTemplateInstantiation {
  StdBasicString() { this.hasQualifiedName(["std", "bsl"], "basic_string") }
}

/**
 * The `std::basic_string::iterator` declaration.
 *
 * Intuitively, this class shouldn't be necessary as it's already captured
 * by the `StdIterator` class. However, this class ensures that the typedef inside the
 * body of the `std::string` class is also seen as an iterator.
 *
 * Eventually, we should be consistent about which of the following should be recognized as iterators:
 * 1. The typedef type.
 * 2. The template class of the resolved type.
 * 3. Any instantiation of the resolved type.
 */
private class StdBasicStringIterator extends Iterator, Type {
  StdBasicStringIterator() {
    this.getEnclosingElement() instanceof StdBasicString and this.hasName("iterator")
  }
}

/**
 * A `std::string` function for which taint should be propagated.
 */
abstract private class StdStringTaintFunction extends TaintFunction {
  /**
   * Gets the index of a parameter to this function that is a string.
   */
  final int getAStringParameterIndex() {
    exists(Type paramType | paramType = this.getParameter(result).getUnspecifiedType() |
      // e.g. `std::basic_string::CharT *`
      paramType instanceof PointerType
      or
      // e.g. `std::basic_string &`, avoiding `const Allocator&`
      paramType instanceof ReferenceType and
      not paramType.(ReferenceType).getBaseType() =
        this.getDeclaringType().getTemplateArgument(2).(Type).getUnspecifiedType()
    )
  }

  /**
   * Gets the index of a parameter to this function that is a character.
   */
  final int getACharParameterIndex() {
    exists(Type paramType | paramType = this.getParameter(result).getUnspecifiedType() |
      // i.e. `std::basic_string::CharT`
      paramType = this.getDeclaringType().getTemplateArgument(0).(Type).getUnspecifiedType()
    )
  }

  /**
   * Gets the index of a parameter to this function that is an iterator.
   */
  final int getAnIteratorParameterIndex() {
    this.getParameter(result).getUnspecifiedType() instanceof Iterator
  }
}

/**
 * Additional model for `std::string` constructors that reference the character
 * type of the container, or an iterator.  For example construction from
 * iterators:
 * ```
 * std::string b(a.begin(), a.end());
 * ```
 */
private class StdStringConstructor extends Constructor, StdStringTaintFunction, SideEffectFunction,
  AliasFunction
{
  StdStringConstructor() { this.getDeclaringType() instanceof StdBasicString }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from any parameter of the value type to the returned object
    (
      input.isParameterDeref(this.getAStringParameterIndex()) or
      input.isParameter(this.getACharParameterIndex()) or
      input.isParameter(this.getAnIteratorParameterIndex())
    ) and
    (
      output.isReturnValue() // TODO: this is only needed for AST data flow, which treats constructors as returning the new object
      or
      output.isQualifierObject()
    )
  }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }
}

private class StdStringDestructor extends Destructor, SideEffectFunction, AliasFunction {
  StdStringDestructor() { this.getDeclaringType() instanceof StdBasicString }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }
}

/**
 * The `std::string` function `c_str`.
 */
class StdStringCStr extends MemberFunction {
  StdStringCStr() { this.getClassAndName("c_str") instanceof StdBasicString }
}

private class StdStringCStrModel extends StdStringCStr, StdStringTaintFunction {
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from string itself (qualifier) to return value
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }
}

/**
 * The `std::string` function `data`.
 */
class StdStringData extends MemberFunction {
  StdStringData() { this.getClassAndName("data") instanceof StdBasicString }
}

private class StdStringDataModel extends StdStringData, StdStringTaintFunction {
  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from string itself (qualifier) to return value
    input.isQualifierObject() and
    output.isReturnValueDeref()
    or
    // reverse flow from returned reference to the qualifier (for writes to
    // `data`)
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }
}

/**
 * The `std::string` function `push_back`.
 */
private class StdStringPush extends StdStringTaintFunction {
  StdStringPush() { this.getClassAndName("push_back") instanceof StdBasicString }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from parameter to qualifier
    input.isParameter(0) and
    output.isQualifierObject()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }
}

/**
 * The `std::string` functions `front` and `back`.
 */
private class StdStringFrontBack extends StdStringTaintFunction {
  StdStringFrontBack() { this.getClassAndName(["front", "back"]) instanceof StdBasicString }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from object to returned reference
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }
}

/**
 * The (non-member) `std::string` function `operator+`.
 */
private class StdStringPlus extends StdStringTaintFunction, SideEffectFunction, AliasFunction {
  StdStringPlus() {
    this.hasQualifiedName(["std", "bsl"], "operator+") and
    this.getUnspecifiedType() instanceof StdBasicString
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from parameters to return value
    (
      input.isParameterDeref(0) or
      input.isParameterDeref(1)
    ) and
    output.isReturnValue()
  }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and
    buffer = false
    or
    this.getParameter(i).getUnspecifiedType() instanceof PointerType and
    buffer = true
  }

  override predicate parameterNeverEscapes(int index) { index = [0, 1] }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }
}

/**
 * The `std::string` functions `operator+=`, `append` and `replace`.
 * All of these functions combine the existing string with a new
 * string (or character) from one of the arguments.
 */
private class StdStringAppend extends StdStringTaintFunction, SideEffectFunction, AliasFunction {
  StdStringAppend() {
    this.getClassAndName(["operator+=", "append", "replace"]) instanceof StdBasicString
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from string and parameter to string (qualifier) and return value
    (
      input.isQualifierObject() or
      input.isParameterDeref(this.getAStringParameterIndex()) or
      input.isParameter(this.getACharParameterIndex()) or
      input.isParameter(this.getAnIteratorParameterIndex())
    ) and
    (
      output.isQualifierObject() or
      output.isReturnValueDeref()
    )
    or
    // reverse flow from returned reference to the qualifier (for writes to
    // the result)
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and mustWrite = false and buffer = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = [-1, 0] and buffer = true
  }

  override predicate parameterNeverEscapes(int index) { index = [-1, 0] }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }
}

/**
 * The `std::string` function `insert`.
 */
private class StdStringInsert extends StdStringTaintFunction {
  StdStringInsert() { this.getClassAndName("insert") instanceof StdBasicString }

  /**
   * Holds if the return type is an iterator.
   */
  predicate hasIteratorReturnValue() { this.getType() instanceof Iterator }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from string and parameter to string (qualifier) and return value
    (
      input.isQualifierObject() or
      input.isParameterDeref(this.getAStringParameterIndex()) or
      input.isParameter(this.getACharParameterIndex()) or
      input.isParameter(this.getAnIteratorParameterIndex())
    ) and
    (
      output.isQualifierObject()
      or
      if this.hasIteratorReturnValue() then output.isReturnValue() else output.isReturnValueDeref()
    )
    or
    // reverse flow from returned reference to the qualifier (for writes to
    // the result)
    not this.hasIteratorReturnValue() and
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }
}

/**
 * The standard function `std::string.assign`.
 */
private class StdStringAssign extends StdStringTaintFunction {
  StdStringAssign() { this.getClassAndName("assign") instanceof StdBasicString }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from parameter to string itself (qualifier) and return value
    (
      input.isParameterDeref(this.getAStringParameterIndex()) or
      input.isParameter(this.getACharParameterIndex()) or
      input.isParameter(this.getAnIteratorParameterIndex())
    ) and
    (
      output.isQualifierObject() or
      output.isReturnValueDeref()
    )
    or
    // reverse flow from returned reference to the qualifier (for writes to
    // the result)
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }
}

/**
 * The standard function `std::string.copy`.
 */
private class StdStringCopy extends StdStringTaintFunction {
  StdStringCopy() { this.getClassAndName("copy") instanceof StdBasicString }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // copy(dest, num, pos)
    input.isQualifierObject() and
    output.isParameterDeref(0)
  }
}

/**
 * The standard function `std::string.substr`.
 */
private class StdStringSubstr extends StdStringTaintFunction {
  StdStringSubstr() { this.getClassAndName("substr") instanceof StdBasicString }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // substr(pos, num)
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * The `std::string` functions `at` and `operator[]`.
 */
private class StdStringAt extends StdStringTaintFunction, SideEffectFunction, AliasFunction {
  StdStringAt() { this.getClassAndName(["at", "operator[]"]) instanceof StdBasicString }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to referenced return value
    input.isQualifierObject() and
    output.isReturnValueDeref()
    or
    // reverse flow from returned reference to the qualifier
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    none()
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }
}

/**
 * The `std::basic_istream` template class instantiations.
 */
private class StdBasicIStream extends ClassTemplateInstantiation {
  StdBasicIStream() { this.hasQualifiedName(["std", "bsl"], "basic_istream") }
}

private class StdBasicIfStream extends ClassTemplateInstantiation {
  StdBasicIfStream() { this.hasQualifiedName(["std", "bsl"], "basic_ifstream") }
}

class StdBasicIfStreamConstructor extends Constructor, SideEffectFunction, AliasFunction {
  StdBasicIfStreamConstructor() { this.getDeclaringType() instanceof StdBasicIfStream }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    exists(Type t | t = this.getParameter(i).getUnspecifiedType() |
      t instanceof PointerType and buffer = true
      or
      t instanceof ReferenceType and buffer = false
    )
  }
}

class StdBasicIfStreamDestructor extends Destructor, SideEffectFunction, AliasFunction {
  StdBasicIfStreamDestructor() { this.getDeclaringType() instanceof StdBasicIfStream }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = -1 and buffer = false
  }
}

/**
 * The `std::istream` function `operator>>` (defined as a member function).
 */
private class StdIStreamIn extends DataFlowFunction, TaintFunction {
  StdIStreamIn() { this.getClassAndName("operator>>") instanceof StdBasicIStream }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // returns reference to `*this`
    input.isQualifierAddress() and
    output.isReturnValue()
    or
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to first parameter
    input.isQualifierObject() and
    output.isParameterDeref(0)
    or
    // reverse flow from returned reference to the qualifier
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }
}

/**
 * The `std::istream` function `operator>>` (defined as a non-member function).
 */
private class StdIStreamInNonMember extends DataFlowFunction, TaintFunction {
  StdIStreamInNonMember() {
    this.hasQualifiedName(["std", "bsl"], "operator>>") and
    this.getUnspecifiedType().(ReferenceType).getBaseType() instanceof StdBasicIStream
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // flow from first parameter to return value
    input.isParameter(0) and
    output.isReturnValue()
    or
    input.isParameterDeref(0) and
    output.isReturnValueDeref()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from first parameter to second parameter
    input.isParameterDeref(0) and
    output.isParameterDeref(1)
    or
    // reverse flow from returned reference to the first parameter
    input.isReturnValueDeref() and
    output.isParameterDeref(0)
  }
}

/**
 * The `std::istream` functions `get` (without parameters) and `peek`.
 */
private class StdIStreamGet extends TaintFunction {
  StdIStreamGet() {
    this.getClassAndName(["get", "peek"]) instanceof StdBasicIStream and
    this.getNumberOfParameters() = 0
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to return value
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * The `std::istream` functions `get` (with parameters) and `read`.
 */
private class StdIStreamRead extends DataFlowFunction, TaintFunction {
  StdIStreamRead() {
    this.getClassAndName(["get", "read"]) instanceof StdBasicIStream and
    this.getNumberOfParameters() > 0
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // returns reference to `*this`
    input.isQualifierAddress() and
    output.isReturnValue()
    or
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to first parameter
    input.isQualifierObject() and
    output.isParameterDeref(0)
    or
    // reverse flow from returned reference to the qualifier
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }
}

/**
 * The `std::istream` function `readsome`.
 */
private class StdIStreamReadSome extends TaintFunction {
  StdIStreamReadSome() { this.getClassAndName("readsome") instanceof StdBasicIStream }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to first parameter
    input.isQualifierObject() and
    output.isParameterDeref(0)
  }
}

/**
 * The `std::istream` function `putback`.
 */
private class StdIStreamPutBack extends DataFlowFunction, TaintFunction {
  StdIStreamPutBack() { this.getClassAndName("putback") instanceof StdBasicIStream }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // returns reference to `*this`
    input.isQualifierAddress() and
    output.isReturnValue()
    or
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from first parameter (value or pointer) to qualifier
    input.isParameter(0) and
    output.isQualifierObject()
    or
    input.isParameterDeref(0) and
    output.isQualifierObject()
    or
    // flow from first parameter (value or pointer) to return value
    input.isParameter(0) and
    output.isReturnValueDeref()
    or
    input.isParameterDeref(0) and
    output.isReturnValueDeref()
    or
    // reverse flow from returned reference to the qualifier
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }
}

/**
 * The `std::istream` function `getline`.
 */
private class StdIStreamGetLine extends DataFlowFunction, TaintFunction {
  StdIStreamGetLine() { this.getClassAndName("getline") instanceof StdBasicIStream }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // returns reference to `*this`
    input.isQualifierAddress() and
    output.isReturnValue()
    or
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to first parameter
    input.isQualifierObject() and
    output.isParameterDeref(0)
    or
    // reverse flow from returned reference to the qualifier
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }
}

/**
 * The (non-member) function `std::getline`.
 */
private class StdGetLine extends DataFlowFunction, TaintFunction {
  StdGetLine() { this.hasQualifiedName(["std", "bsl"], "getline") }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // flow from first parameter to return value
    input.isParameter(0) and
    output.isReturnValue()
    or
    input.isParameterDeref(0) and
    output.isReturnValueDeref()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from first parameter to second parameter
    input.isParameterDeref(0) and
    output.isParameterDeref(1)
    or
    // reverse flow from returned reference to first parameter
    input.isReturnValueDeref() and
    output.isParameterDeref(0)
  }
}

/**
 * The `std::basic_ostream` template class instantiations.
 */
private class StdBasicOStream extends ClassTemplateInstantiation {
  StdBasicOStream() { this.hasQualifiedName(["std", "bsl"], "basic_ostream") }
}

private class StdStringLessThan extends Function, AliasFunction, SideEffectFunction {
  StdStringLessThan() {
    this.hasQualifiedName(["std", "bsl"], "operator<") and
    this.getNumberOfParameters() = 2 and
    this.getParameter(0).getUnspecifiedType().(ReferenceType).getBaseType() instanceof
      StdBasicString and
    this.getParameter(1).getUnspecifiedType().(ReferenceType).getBaseType() instanceof
      StdBasicString
  }

  override predicate parameterNeverEscapes(int index) { index = [0, 1] }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    none()
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = [0, 1] and buffer = false
  }
}

/**
 * The `std::ostream` functions `operator<<` (defined as a member function),
 * `put` and `write`.
 */
private class StdOStreamOut extends DataFlowFunction, TaintFunction {
  StdOStreamOut() {
    this.getClassAndName(["operator<<", "put", "write"]) instanceof StdBasicOStream
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // returns reference to `*this`
    input.isQualifierAddress() and
    output.isReturnValue()
    or
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from first parameter (value or pointer) to qualifier
    input.isParameter(0) and
    output.isQualifierObject()
    or
    input.isParameterDeref(0) and
    output.isQualifierObject()
    or
    // flow from first parameter (value or pointer) to return value
    input.isParameter(0) and
    output.isReturnValueDeref()
    or
    input.isParameterDeref(0) and
    output.isReturnValueDeref()
    or
    // reverse flow from returned reference to the qualifier
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }
}

/**
 * The `std::ostream` function `operator<<` (defined as a non-member function).
 */
private class StdOStreamOutNonMember extends DataFlowFunction, TaintFunction {
  StdOStreamOutNonMember() {
    this.hasQualifiedName(["std", "bsl"], "operator<<") and
    this.getUnspecifiedType().(ReferenceType).getBaseType() instanceof StdBasicOStream
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // flow from first parameter to return value
    input.isParameter(0) and
    output.isReturnValue()
    or
    input.isParameterDeref(0) and
    output.isReturnValueDeref()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isParameterDeref(0) }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from second parameter to first parameter
    input.isParameterDeref(1) and
    output.isParameterDeref(0)
    or
    // flow from second parameter to return value
    input.isParameterDeref(1) and
    output.isReturnValueDeref()
    or
    // reverse flow from returned reference to the first parameter
    input.isReturnValueDeref() and
    output.isParameterDeref(0)
  }
}

/**
 * The `std::basic_stringstream` template class instantiations.
 */
private class StdBasicStringStream extends ClassTemplateInstantiation {
  StdBasicStringStream() { this.hasQualifiedName(["std", "bsl"], "basic_stringstream") }
}

/**
 * Additional model for `std::stringstream` constructors that take a string
 * input parameter.
 */
private class StdStringStreamConstructor extends Constructor, TaintFunction {
  StdStringStreamConstructor() { this.getDeclaringType() instanceof StdBasicStringStream }

  /**
   * Gets the index of a parameter to this function that is a string.
   */
  int getAStringParameterIndex() {
    this.getParameter(result).getType() instanceof ReferenceType // `const std::basic_string &`
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from any parameter of string type to the returned object
    input.isParameterDeref(this.getAStringParameterIndex()) and
    (
      output.isReturnValue() // TODO: this is only needed for AST data flow, which treats constructors as returning the new object
      or
      output.isQualifierObject()
    )
  }
}

/**
 * The `std::stringstream` function `str`.
 */
private class StdStringStreamStr extends TaintFunction {
  StdStringStreamStr() { this.getClassAndName("str") instanceof StdBasicStringStream }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to return value (if any)
    input.isQualifierObject() and
    output.isReturnValue()
    or
    // flow from first parameter (if any) to qualifier
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}

/**
 * The `std::basic_ios` template class instantiations.
 */
private class StdBasicIOS extends ClassTemplateInstantiation {
  StdBasicIOS() { this.hasQualifiedName(["std", "bsl"], "basic_ios") }
}

/**
 * A `std::` stream function that does not require a model, except that it
 * returns a reference to `*this` and thus could be used in a chain.
 */
private class StdStreamFunction extends DataFlowFunction, TaintFunction {
  StdStreamFunction() {
    this.getClassAndName(["ignore", "unget", "seekg"]) instanceof StdBasicIStream
    or
    this.getClassAndName(["seekp", "flush"]) instanceof StdBasicOStream
    or
    this.getClassAndName("copyfmt") instanceof StdBasicIOS
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // returns reference to `*this`
    input.isQualifierAddress() and
    output.isReturnValue()
    or
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }

  override predicate isPartialWrite(FunctionOutput output) { output.isQualifierObject() }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // reverse flow from returned reference to the qualifier
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }
}
