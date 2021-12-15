private import codeql_ql.ast.internal.Type

predicate isBuiltinClassless(string sig) {
  sig =
    [
      "predicate any()", "predicate none()", "predicate toUrl(string, int, int, int, string)",
      "predicate toUrl(string, int, int, int, int, string)"
    ]
}

predicate isBuiltinClassless(string ret, string name, string args) {
  exists(string sig, string re | re = "(\\w+) (\\w+)\\(([\\w, ]*)\\)" |
    isBuiltinClassless(sig) and
    ret = sig.regexpCapture(re, 1) and
    name = sig.regexpCapture(re, 2) and
    args = sig.regexpCapture(re, 3)
  )
}

predicate isBuiltinMember(string sig) {
  sig =
    [
      "boolean boolean.booleanAnd(boolean)", "boolean boolean.booleanOr(boolean)",
      "boolean boolean.booleanXor(boolean)", "boolean boolean.booleanNot()",
      "string boolean.toString()", "float float.abs()", "float float.acos()", "float float.atan()",
      "int float.ceil()", "float float.copySign(float)", "float float.cos()", "float float.cosh()",
      "float float.exp()", "int float.floor()", "float float.log()", "float float.log(float)",
      "float float.log2()", "float float.log10()", "float float.maximum(float)",
      "float float.minimum(float)", "float float.nextAfter(float)", "float float.nextDown()",
      "float float.nextUp()", "float float.pow(float)", "float float.signum()", "float float.sin()",
      "float float.sinh()", "float float.sqrt()", "float float.tan()", "float float.tanh()",
      "string float.toString()", "float float.ulp()", "int int.abs()", "int int.bitAnd(int)",
      "int int.bitOr(int)", "int int.bitNot()", "int int.bitXor(int)", "int int.bitShiftLeft(int)",
      "int int.bitShiftRight(int)", "int int.bitShiftRightSigned(int)", "int int.gcd(int)",
      "string int.toString()", "string string.charAt(int)", "int string.indexOf(string)",
      "int string.indexOf(string, int, int)", "predicate string.isLowercase()",
      "predicate string.isUppercase()", "int string.length()", "predicate string.matches(string)",
      "string string.prefix(int)", "string string.regexpCapture(string, int)",
      "string string.regexpFind(string, int, int)", "predicate string.regexpMatch(string)",
      "string string.regexpReplaceAll(string, string)", "string string.replaceAll(string, string)",
      "string string.splitAt(string)", "string string.splitAt(string, int)",
      "string string.substring(int, int)", "string string.suffix(int)", "date string.toDate()",
      "float string.toFloat()", "int string.toInt()", "string string.toString()",
      "string string.toLowerCase()", "string string.toUpperCase()", "string string.trim()",
      "int date.daysTo(date)", "int date.getDay()", "int date.getHours()", "int date.getMinutes()",
      "int date.getMonth()", "int date.getSeconds()", "int date.getYear()",
      "string date.toString()", "string date.toISO()", "string int.toUnicode()",
      "string any.getAQlClass()"
      /* getAQlClass is special , see Predicate.qll*/
    ]
}

predicate isBuiltinMember(string qual, string ret, string name, string args) {
  exists(string sig, string re | re = "(\\w+) (\\w+)\\.(\\w+)\\(([\\w, ]*)\\)" |
    isBuiltinMember(sig) and
    ret = sig.regexpCapture(re, 1) and
    qual = sig.regexpCapture(re, 2) and
    name = sig.regexpCapture(re, 3) and
    args = sig.regexpCapture(re, 4)
  )
}

module BuiltinsConsistency {
  query predicate noBuildinParse(string sig) {
    isBuiltinMember(sig) and
    not exists(sig.regexpCapture("(\\w+) (\\w+)\\.(\\w+)\\(([\\w, ]*)\\)", _))
  }

  query predicate noBuildinClasslessParse(string sig) {
    isBuiltinClassless(sig) and
    not exists(sig.regexpCapture("(\\w+) (\\w+)\\(([\\w, ]*)\\)", _))
  }
}

bindingset[args]
string getArgType(string args, int i) { result = args.splitAt(",", i).trim() }

/** The primitive 'string' class. */
class StringClass extends PrimitiveType {
  StringClass() { this.getName() = "string" }
}

/** The primitive 'int' class. */
class IntClass extends PrimitiveType {
  IntClass() { this.getName() = "int" }
}

/** The primitive 'float' class. */
class FloatClass extends PrimitiveType {
  FloatClass() { this.getName() = "float" }
}

/** The primitive 'boolean' class. */
class BooleanClass extends PrimitiveType {
  BooleanClass() { this.getName() = "boolean" }
}
