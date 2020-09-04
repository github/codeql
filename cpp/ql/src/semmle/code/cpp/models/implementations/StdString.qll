/**
 * Provides implementation classes modeling `std::string` and other
 * instantiations of `std::basic_string`. See `semmle.code.cpp.models.Models`
 * for usage information.
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
    output.isReturnValue() // TODO: this should be `isQualifierObject` by our current definitions, but that flow is not yet supported.
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
  }
}

/**
 * The standard functions `std::string.begin` and `std::string.end` and their
 * variants.
 */
class StdStringBeginEnd extends TaintFunction {
  StdStringBeginEnd() {
    this
        .hasQualifiedName("std", "basic_string",
          ["begin", "cbegin", "rbegin", "crbegin", "end", "cend", "rend", "crend"])
  }

  override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
    input.isQualifierObject() and
    output.isReturnValue()
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
 * The standard function `std::string.swap`.
 */
class StdStringSwap extends TaintFunction {
  StdStringSwap() { this.hasQualifiedName("std", "basic_string", "swap") }

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
