/**
 * Provides implementation classes modeling `std::string` (and other
 * instantiations of `std::basic_string`) and `std::ostream`. See
 * `semmle.code.cpp.models.Models` for usage information.
 */

import semmle.code.cpp.models.interfaces.Taint
import semmle.code.cpp.models.implementations.Iterator

/**
 * The `std::basic_string` template class.
 */
class StdBasicString extends TemplateClass {
  StdBasicString() { this.hasQualifiedName("std", "basic_string") }
}

/**
 * Additional model for `std::string` constructors that reference the character
 * type of the container, or an iterator.  For example construction from
 * iterators:
 * ```
 * std::string b(a.begin(), a.end());
 * ```
 */
class StdStringConstructor extends Constructor, TaintFunction {
  StdStringConstructor() { this.getDeclaringType().hasQualifiedName("std", "basic_string") }

  /**
   * Gets the index of a parameter to this function that is a string (or
   * character).
   */
  int getAStringParameterIndex() {
    getParameter(result).getType() instanceof PointerType or // e.g. `std::basic_string::CharT *`
    getParameter(result).getType() instanceof ReferenceType or // e.g. `std::basic_string &`
    getParameter(result).getUnspecifiedType() =
      getDeclaringType().getTemplateArgument(0).(Type).getUnspecifiedType() // i.e. `std::basic_string::CharT`
  }

  /**
   * Gets the index of a parameter to this function that is an iterator.
   */
  int getAnIteratorParameterIndex() { getParameter(result).getType() instanceof Iterator }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from any parameter of the value type to the returned object
    (
      input.isParameterDeref(getAStringParameterIndex()) or
      input.isParameter(getAnIteratorParameterIndex())
    ) and
    (
      output.isReturnValue() // TODO: this is only needed for AST data flow, which treats constructors as returning the new object
      or
      output.isQualifierObject()
    )
  }
}

/**
 * The `std::string` function `c_str`.
 */
class StdStringCStr extends TaintFunction {
  StdStringCStr() { this.hasQualifiedName("std", "basic_string", "c_str") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from string itself (qualifier) to return value
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }
}

/**
 * The `std::string` function `data`.
 */
class StdStringData extends TaintFunction {
  StdStringData() { this.hasQualifiedName("std", "basic_string", "data") }

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
}

/**
 * The `std::string` function `push_back`.
 */
class StdStringPush extends TaintFunction {
  StdStringPush() { this.hasQualifiedName("std", "basic_string", "push_back") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from parameter to qualifier
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}

/**
 * The `std::string` functions `front` and `back`.
 */
class StdStringFrontBack extends TaintFunction {
  StdStringFrontBack() { this.hasQualifiedName("std", "basic_string", ["front", "back"]) }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from object to returned reference
    input.isQualifierObject() and
    output.isReturnValueDeref()
  }
}

/**
 * The `std::string` function `operator+`.
 */
class StdStringPlus extends TaintFunction {
  StdStringPlus() {
    this.hasQualifiedName("std", "operator+") and
    this.getUnspecifiedType() = any(StdBasicString s).getAnInstantiation()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from parameters to return value
    (
      input.isParameterDeref(0) or
      input.isParameterDeref(1)
    ) and
    output.isReturnValue()
  }
}

/**
 * The `std::string` functions `operator+=`, `append`, `insert` and
 * `replace`. All of these functions combine the existing string
 * with a new string (or character) from one of the arguments.
 */
class StdStringAppend extends TaintFunction {
  StdStringAppend() {
    this.hasQualifiedName("std", "basic_string", ["operator+=", "append", "insert", "replace"])
  }

  /**
   * Gets the index of a parameter to this function that is a string (or
   * character).
   */
  int getAStringParameterIndex() {
    getParameter(result).getType() instanceof PointerType or // e.g. `std::basic_string::CharT *`
    getParameter(result).getType() instanceof ReferenceType or // e.g. `std::basic_string &`
    getParameter(result).getUnspecifiedType() =
      getDeclaringType().getTemplateArgument(0).(Type).getUnspecifiedType() // i.e. `std::basic_string::CharT`
  }

  /**
   * Gets the index of a parameter to this function that is an iterator.
   */
  int getAnIteratorParameterIndex() { getParameter(result).getType() instanceof Iterator }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from string and parameter to string (qualifier) and return value
    (
      input.isQualifierObject() or
      input.isParameterDeref(getAStringParameterIndex()) or
      input.isParameter(getAnIteratorParameterIndex())
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
 * The standard function `std::string.assign`.
 */
class StdStringAssign extends TaintFunction {
  StdStringAssign() { this.hasQualifiedName("std", "basic_string", "assign") }

  /**
   * Gets the index of a parameter to this function that is a string (or
   * character).
   */
  int getAStringParameterIndex() {
    getParameter(result).getType() instanceof PointerType or // e.g. `std::basic_string::CharT *`
    getParameter(result).getType() instanceof ReferenceType or // e.g. `std::basic_string &`
    getParameter(result).getUnspecifiedType() =
      getDeclaringType().getTemplateArgument(0).(Type).getUnspecifiedType() // i.e. `std::basic_string::CharT`
  }

  /**
   * Gets the index of a parameter to this function that is an iterator.
   */
  int getAnIteratorParameterIndex() { getParameter(result).getType() instanceof Iterator }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from parameter to string itself (qualifier) and return value
    (
      input.isParameterDeref(getAStringParameterIndex()) or
      input.isParameter(getAnIteratorParameterIndex())
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
class StdStringCopy extends TaintFunction {
  StdStringCopy() { this.hasQualifiedName("std", "basic_string", "copy") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // copy(dest, num, pos)
    input.isQualifierObject() and
    output.isParameterDeref(0)
  }
}

/**
 * The standard function `std::string.substr`.
 */
class StdStringSubstr extends TaintFunction {
  StdStringSubstr() { this.hasQualifiedName("std", "basic_string", "substr") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // substr(pos, num)
    input.isQualifierObject() and
    output.isReturnValue()
  }
}

/**
 * The standard functions `std::string.swap` and `std::stringstream::swap`.
 */
class StdStringSwap extends TaintFunction {
  StdStringSwap() {
    this.hasQualifiedName("std", "basic_string", "swap") or
    this.hasQualifiedName("std", "basic_stringstream", "swap")
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // str1.swap(str2)
    input.isQualifierObject() and
    output.isParameterDeref(0)
    or
    input.isParameterDeref(0) and
    output.isQualifierObject()
  }
}

/**
 * The `std::string` functions `at` and `operator[]`.
 */
class StdStringAt extends TaintFunction {
  StdStringAt() { this.hasQualifiedName("std", "basic_string", ["at", "operator[]"]) }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to referenced return value
    input.isQualifierObject() and
    output.isReturnValueDeref()
    or
    // reverse flow from returned reference to the qualifier
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }
}

/**
 * The `std::basic_istream` template class.
 */
class StdBasicIStream extends TemplateClass {
  StdBasicIStream() { this.hasQualifiedName("std", "basic_istream") }
}

/**
 * The `std::istream` function `operator>>` (defined as a member function).
 */
class StdIStreamIn extends DataFlowFunction, TaintFunction {
  StdIStreamIn() { this.hasQualifiedName("std", "basic_istream", "operator>>") }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // returns reference to `*this`
    input.isQualifierAddress() and
    output.isReturnValue()
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
}

/**
 * The `std::istream` function `operator>>` (defined as a non-member function).
 */
class StdIStreamInNonMember extends DataFlowFunction, TaintFunction {
  StdIStreamInNonMember() {
    this.hasQualifiedName("std", "operator>>") and
    this.getUnspecifiedType().(ReferenceType).getBaseType() =
      any(StdBasicIStream s).getAnInstantiation()
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // flow from first parameter to return value
    input.isParameter(0) and
    output.isReturnValue()
  }

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
class StdIStreamGet extends TaintFunction {
  StdIStreamGet() {
    this.hasQualifiedName("std", "basic_istream", ["get", "peek"]) and
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
class StdIStreamRead extends DataFlowFunction, TaintFunction {
  StdIStreamRead() {
    this.hasQualifiedName("std", "basic_istream", ["get", "read"]) and
    this.getNumberOfParameters() > 0
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // returns reference to `*this`
    input.isQualifierAddress() and
    output.isReturnValue()
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
}

/**
 * The `std::istream` function `readsome`.
 */
class StdIStreamReadSome extends TaintFunction {
  StdIStreamReadSome() { this.hasQualifiedName("std", "basic_istream", "readsome") }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from qualifier to first parameter
    input.isQualifierObject() and
    output.isParameterDeref(0)
  }
}

/**
 * The `std::istream` function `putback`.
 */
class StdIStreamPutBack extends DataFlowFunction, TaintFunction {
  StdIStreamPutBack() { this.hasQualifiedName("std", "basic_istream", "putback") }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // returns reference to `*this`
    input.isQualifierAddress() and
    output.isReturnValue()
  }

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
class StdIStreamGetLine extends DataFlowFunction, TaintFunction {
  StdIStreamGetLine() { this.hasQualifiedName("std", "basic_istream", "getline") }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // returns reference to `*this`
    input.isQualifierAddress() and
    output.isReturnValue()
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
}

/**
 * The (non-member) function `std::getline`.
 */
class StdGetLine extends DataFlowFunction, TaintFunction {
  StdGetLine() { this.hasQualifiedName("std", "getline") }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // flow from first parameter to return value
    input.isParameter(0) and
    output.isReturnValue()
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
 * The `std::basic_ostream` template class.
 */
class StdBasicOStream extends TemplateClass {
  StdBasicOStream() { this.hasQualifiedName("std", "basic_ostream") }
}

/**
 * The `std::ostream` functions `operator<<` (defined as a member function),
 * `put` and `write`.
 */
class StdOStreamOut extends DataFlowFunction, TaintFunction {
  StdOStreamOut() { this.hasQualifiedName("std", "basic_ostream", ["operator<<", "put", "write"]) }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // returns reference to `*this`
    input.isQualifierAddress() and
    output.isReturnValue()
  }

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
class StdOStreamOutNonMember extends DataFlowFunction, TaintFunction {
  StdOStreamOutNonMember() {
    this.hasQualifiedName("std", "operator<<") and
    this.getUnspecifiedType().(ReferenceType).getBaseType() =
      any(StdBasicOStream s).getAnInstantiation()
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // flow from first parameter to return value
    input.isParameter(0) and
    output.isReturnValue()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // flow from second parameter to first parameter
    input.isParameter(1) and
    output.isParameterDeref(0)
    or
    // flow from second parameter to return value
    input.isParameter(1) and
    output.isReturnValueDeref()
    or
    // reverse flow from returned reference to the first parameter
    input.isReturnValueDeref() and
    output.isParameterDeref(0)
  }
}

/**
 * Additional model for `std::stringstream` constructors that take a string
 * input parameter.
 */
class StdStringStreamConstructor extends Constructor, TaintFunction {
  StdStringStreamConstructor() {
    this.getDeclaringType().hasQualifiedName("std", "basic_stringstream")
  }

  /**
   * Gets the index of a parameter to this function that is a string.
   */
  int getAStringParameterIndex() {
    getParameter(result).getType() instanceof ReferenceType // `const std::basic_string &`
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // taint flow from any parameter of string type to the returned object
    input.isParameterDeref(getAStringParameterIndex()) and
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
class StdStringStreamStr extends TaintFunction {
  StdStringStreamStr() { this.hasQualifiedName("std", "basic_stringstream", "str") }

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
 * A `std::` stream function that does not require a model, except that it
 * returns a reference to `*this` and thus could be used in a chain.
 */
class StdStreamFunction extends DataFlowFunction, TaintFunction {
  StdStreamFunction() {
    this.hasQualifiedName("std", "basic_istream", ["ignore", "unget", "seekg"]) or
    this.hasQualifiedName("std", "basic_ostream", ["seekp", "flush"]) or
    this.hasQualifiedName("std", "basic_ios", "copyfmt")
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // returns reference to `*this`
    input.isQualifierAddress() and
    output.isReturnValue()
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    // reverse flow from returned reference to the qualifier
    input.isReturnValueDeref() and
    output.isQualifierObject()
  }
}
