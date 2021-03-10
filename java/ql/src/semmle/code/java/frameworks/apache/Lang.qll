/** Definitions related to the Apache Commons Lang library. */

import java
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.ExternalFlow

/**
 * The class `org.apache.commons.lang.RandomStringUtils` or `org.apache.commons.lang3.RandomStringUtils`.
 */
class TypeApacheRandomStringUtils extends Class {
  TypeApacheRandomStringUtils() {
    this.hasQualifiedName(["org.apache.commons.lang", "org.apache.commons.lang3"],
      "RandomStringUtils")
  }
}

/**
 * The class `org.apache.commons.lang.ArrayUtils` or `org.apache.commons.lang3.ArrayUtils`.
 */
class TypeApacheArrayUtils extends Class {
  TypeApacheArrayUtils() {
    hasQualifiedName(["org.apache.commons.lang", "org.apache.commons.lang3"], "ArrayUtils")
  }
}

/**
 * The method `deserialize` in either `org.apache.commons.lang.SerializationUtils`
 * or `org.apache.commons.lang3.SerializationUtils`.
 */
class MethodApacheSerializationUtilsDeserialize extends Method {
  MethodApacheSerializationUtilsDeserialize() {
    this.getDeclaringType()
        .hasQualifiedName(["org.apache.commons.lang", "org.apache.commons.lang3"],
          "SerializationUtils") and
    this.hasName("deserialize")
  }
}

/**
 * A taint preserving method on `org.apache.commons.lang.ArrayUtils` or `org.apache.commons.lang3.ArrayUtils`
 */
private class ApacheLangArrayUtilsTaintPreservingMethod extends TaintPreservingCallable {
  ApacheLangArrayUtilsTaintPreservingMethod() {
    this.getDeclaringType() instanceof TypeApacheArrayUtils
  }

  override predicate returnsTaintFrom(int src) {
    this.hasName(["addAll", "addFirst"]) and
    src = [0 .. getNumberOfParameters() - 1]
    or
    this.hasName([
        "clone", "nullToEmpty", "remove", "removeAll", "removeElement", "removeElements",
        "subarray", "toArray", "toMap", "toObject", "removeAllOccurences", "removeAllOccurrences"
      ]) and
    src = 0
    or
    this.hasName("toPrimitive") and
    src = [0, 1]
    or
    this.hasName("add") and
    this.getNumberOfParameters() = 2 and
    src = [0, 1]
    or
    this.hasName(["add"]) and
    this.getNumberOfParameters() = 3 and
    src = [0, 2]
    or
    this.hasName("insert") and
    src = [1, 2]
    or
    this.hasName("get") and
    src = [0, 2]
  }
}

private Type getAnExcludedParameterType() {
  result instanceof PrimitiveType or
  result.(RefType).hasQualifiedName("java.nio.charset", "Charset") or
  result.(RefType).hasQualifiedName("java.util", "Locale")
}

private class ApacheStringUtilsTaintPreservingMethod extends TaintPreservingCallable {
  ApacheStringUtilsTaintPreservingMethod() {
    this.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "StringUtils") and
    this.hasName([
        "abbreviate", "abbreviateMiddle", "appendIfMissing", "appendIfMissingIgnoreCase",
        "capitalize", "center", "chomp", "chop", "defaultIfBlank", "defaultIfEmpty",
        "defaultString", "deleteWhitespace", "difference", "firstNonBlank", "firstNonEmpty",
        "getBytes", "getCommonPrefix", "getDigits", "getIfBlank", "getIfEmpty", "join", "joinWith",
        "left", "leftPad", "lowerCase", "mid", "normalizeSpace", "overlay", "prependIfMissing",
        "prependIfMissingIgnoreCase", "remove", "removeAll", "removeEnd", "removeEndIgnoreCase",
        "removeFirst", "removeIgnoreCase", "removePattern", "removeStart", "removeStartIgnoreCase",
        "repeat", "replace", "replaceAll", "replaceChars", "replaceEach", "replaceEachRepeatedly",
        "replaceFirst", "replaceIgnoreCase", "replaceOnce", "replaceOnceIgnoreCase",
        "replacePattern", "reverse", "reverseDelimited", "right", "rightPad", "rotate", "split",
        "splitByCharacterType", "splitByCharacterTypeCamelCase", "splitByWholeSeparator",
        "splitByWholeSeparatorPreserveAllTokens", "splitPreserveAllTokens", "strip", "stripAccents",
        "stripAll", "stripEnd", "stripStart", "stripToEmpty", "stripToNull", "substring",
        "substringAfter", "substringAfterLast", "substringBefore", "substringBeforeLast",
        "substringBetween", "substringsBetween", "swapCase", "toCodePoints", "toEncodedString",
        "toRootLowerCase", "toRootUpperCase", "toString", "trim", "trimToEmpty", "trimToNull",
        "truncate", "uncapitalize", "unwrap", "upperCase", "valueOf", "wrap", "wrapIfMissing"
      ])
  }

  private predicate isExcludedParameter(int arg) {
    this.getName().matches(["appendIfMissing%", "prependIfMissing%"]) and arg = [2, 3]
    or
    this.getName().matches(["remove%", "split%", "substring%", "strip%"]) and
    arg = [1 .. getNumberOfParameters() - 1]
    or
    this.getName().matches(["chomp", "getBytes", "replace%", "toString", "unwrap"]) and arg = 1
    or
    this.getName() = "join" and
    // Exclude joins of types that render numerically (char[] and non-primitive arrays
    // are still considered taint sources)
    exists(PrimitiveType pt |
      this.getParameterType(arg).(Array).getComponentType() = pt and
      not pt instanceof CharacterType
    ) and
    arg = 0
  }

  override predicate returnsTaintFrom(int arg) {
    arg = [0 .. getNumberOfParameters() - 1] and
    not this.getParameterType(arg) = getAnExcludedParameterType() and
    not isExcludedParameter(arg)
  }
}

/**
 * A method declared on Apache Commons Lang's `StrBuilder`, or the same class or its
 * renamed version `TextStringBuilder` in Commons Text.
 */
class ApacheStrBuilderCallable extends Callable {
  ApacheStrBuilderCallable() {
    this.getDeclaringType().hasQualifiedName("org.apache.commons.lang3.text", "StrBuilder") or
    this.getDeclaringType()
        .hasQualifiedName("org.apache.commons.text", ["StrBuilder", "TextStringBuilder"])
  }
}

/**
 * An Apache Commons Lang `StrBuilder` method that adds taint to the `StrBuilder`.
 */
private class ApacheStrBuilderTaintingMethod extends ApacheStrBuilderCallable,
  TaintPreservingCallable {
  ApacheStrBuilderTaintingMethod() {
    this instanceof Constructor
    or
    this.hasName([
        "append", "appendAll", "appendFixedWidthPadLeft", "appendFixedWidthPadRight", "appendln",
        "appendSeparator", "appendWithSeparators", "insert", "readFrom", "replace", "replaceAll",
        "replaceFirst"
      ])
  }

  private predicate consumesTaintFromAllArgs() {
    // Specifically the append[ln](String, Object...) overloads also consume taint from their other arguments:
    this.getName() in ["appendAll", "appendWithSeparators"]
    or
    this.getName() = ["append", "appendln"] and this.getAParameter().isVarargs()
    or
    this.getName() = "appendSeparator" and this.getParameterType(1) instanceof TypeString
  }

  override predicate transfersTaint(int fromArg, int toArg) {
    // Taint the qualifier
    toArg = -1 and
    (
      this.getName().matches(["append%", "readFrom"]) and fromArg = 0
      or
      this.getName() = "insert" and fromArg = 1
      or
      this.getName().matches("replace%") and
      (
        if this.getParameterType(0).(PrimitiveType).getName() = "int"
        then fromArg = 2
        else fromArg = 1
      )
      or
      this.consumesTaintFromAllArgs() and fromArg in [0 .. this.getNumberOfParameters() - 1]
    )
  }

  override predicate returnsTaintFrom(int arg) { this instanceof Constructor and arg = 0 }
}

/**
 * An Apache Commons Lang `StrBuilder` method that returns taint from the `StrBuilder`.
 */
private class ApacheStrBuilderTaintGetter extends ApacheStrBuilderCallable, TaintPreservingCallable {
  ApacheStrBuilderTaintGetter() {
    // Taint getters:
    this.hasName([
        "asReader", "asTokenizer", "build", "getChars", "leftString", "midString", "rightString",
        "subSequence", "substring", "toCharArray", "toString", "toStringBuffer", "toStringBuilder"
      ])
    or
    // Fluent methods that return an alias of `this`:
    this.getReturnType() = this.getDeclaringType()
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
}

/**
 * An Apache Commons Lang `StrBuilder` method that writes taint from the `StrBuilder` to some parameter.
 */
private class ApacheStrBuilderTaintWriter extends ApacheStrBuilderCallable, TaintPreservingCallable {
  ApacheStrBuilderTaintWriter() { this.hasName(["appendTo", "getChars"]) }

  override predicate transfersTaint(int fromArg, int toArg) {
    fromArg = -1 and
    // appendTo(Readable) and getChars(char[])
    if this.getNumberOfParameters() = 1
    then toArg = 0
    else
      // getChars(int, int, char[], int)
      toArg = 2
  }
}

/**
 * Taint-propagating models for `WordUtils`.
 */
private class ApacheWordUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.lang3.text;WordUtils;false;wrap;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3.text;WordUtils;false;wrap;(java.lang.String,int,java.lang.String,boolean);;Argument[2];ReturnValue;taint",
        "org.apache.commons.lang3.text;WordUtils;false;wrap;(java.lang.String,int,java.lang.String,boolean,java.lang.String);;Argument[2];ReturnValue;taint",
        "org.apache.commons.lang3.text;WordUtils;false;uncapitalize;(java.lang.String);;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;WordUtils;false;uncapitalize;(java.lang.String,char[]);;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3.text;WordUtils;false;swapCase;;;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;WordUtils;false;capitalize;(java.lang.String);;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;WordUtils;false;capitalize;(java.lang.String,char[]);;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3.text;WordUtils;false;initials;(java.lang.String);;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;WordUtils;false;initials;(java.lang.String,char[]);;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3.text;WordUtils;false;capitalizeFully;(java.lang.String);;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;WordUtils;false;capitalizeFully;(java.lang.String,char[]);;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;WordUtils;false;wrap;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;WordUtils;false;wrap;(java.lang.String,int,java.lang.String,boolean);;Argument[2];ReturnValue;taint",
        "org.apache.commons.text;WordUtils;false;wrap;(java.lang.String,int,java.lang.String,boolean,java.lang.String);;Argument[2];ReturnValue;taint",
        "org.apache.commons.text;WordUtils;false;uncapitalize;(java.lang.String);;Argument;ReturnValue;taint",
        "org.apache.commons.text;WordUtils;false;uncapitalize;(java.lang.String,char[]);;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;WordUtils;false;swapCase;;;Argument;ReturnValue;taint",
        "org.apache.commons.text;WordUtils;false;capitalize;(java.lang.String);;Argument;ReturnValue;taint",
        "org.apache.commons.text;WordUtils;false;capitalize;(java.lang.String,char[]);;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;WordUtils;false;abbreviate;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;WordUtils;false;abbreviate;;;Argument[3];ReturnValue;taint",
        "org.apache.commons.text;WordUtils;false;initials;(java.lang.String);;Argument;ReturnValue;taint",
        "org.apache.commons.text;WordUtils;false;initials;(java.lang.String,char[]);;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;WordUtils;false;capitalizeFully;(java.lang.String);;Argument;ReturnValue;taint",
        "org.apache.commons.text;WordUtils;false;capitalizeFully;(java.lang.String,char[]);;Argument[0];ReturnValue;taint"
      ]
  }
}

/**
 * Taint-propagating models for `StrTokenizer`.
 */
private class ApacheStrTokenizerModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.lang3.text;StrTokenizer;false;StrTokenizer;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrTokenizer;false;clone;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrTokenizer;false;toString;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrTokenizer;false;reset;;;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;StrTokenizer;false;reset;;;Argument;Argument[-1];taint",
        "org.apache.commons.lang3.text;StrTokenizer;false;next;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrTokenizer;false;getContent;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrTokenizer;false;previous;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrTokenizer;false;getTokenList;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrTokenizer;false;getTokenArray;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrTokenizer;false;previousToken;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrTokenizer;false;nextToken;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrTokenizer;false;getTSVInstance;;;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;StrTokenizer;false;getCSVInstance;;;Argument;ReturnValue;taint",
        "org.apache.commons.text;StrTokenizer;false;StrTokenizer;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;StrTokenizer;false;clone;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StrTokenizer;false;toString;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StrTokenizer;false;reset;;;Argument;ReturnValue;taint",
        "org.apache.commons.text;StrTokenizer;false;reset;;;Argument;Argument[-1];taint",
        "org.apache.commons.text;StrTokenizer;false;next;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StrTokenizer;false;getContent;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StrTokenizer;false;previous;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StrTokenizer;false;getTokenList;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StrTokenizer;false;getTokenArray;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StrTokenizer;false;previousToken;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StrTokenizer;false;nextToken;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StrTokenizer;false;getTSVInstance;;;Argument;ReturnValue;taint",
        "org.apache.commons.text;StrTokenizer;false;getCSVInstance;;;Argument;ReturnValue;taint",
        "org.apache.commons.text;StringTokenizer;false;StringTokenizer;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;StringTokenizer;false;clone;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StringTokenizer;false;toString;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StringTokenizer;false;reset;;;Argument;ReturnValue;taint",
        "org.apache.commons.text;StringTokenizer;false;reset;;;Argument;Argument[-1];taint",
        "org.apache.commons.text;StringTokenizer;false;next;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StringTokenizer;false;getContent;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StringTokenizer;false;previous;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StringTokenizer;false;getTokenList;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StringTokenizer;false;getTokenArray;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StringTokenizer;false;previousToken;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StringTokenizer;false;nextToken;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StringTokenizer;false;getTSVInstance;;;Argument;ReturnValue;taint",
        "org.apache.commons.text;StringTokenizer;false;getCSVInstance;;;Argument;ReturnValue;taint"
      ]
  }
}

/**
 * Taint-propagating models for `StrLookup`.
 */
private class ApacheStrLookupModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.lang3.text;StrLookup;false;lookup;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrLookup;false;mapLookup;;;Argument;ReturnValue;taint",
        "org.apache.commons.text.lookup;StringLookup;true;lookup;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text.lookup;StringLookupFactory;false;mapStringLookup;;;Argument;ReturnValue;taint"
      ]
  }
}

/**
 * Taint-propagating models for `StrSubstitutor`.
 */
private class ApacheStrSubstitutorModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.lang3.text;StrSubstitutor;false;StrSubstitutor;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(java.lang.Object);;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(char[]);;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(char[],int,int);;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(java.lang.CharSequence);;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(java.lang.CharSequence,int,int);;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(java.lang.String);;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(org.apache.commons.lang3.text.StrBuilder);;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(java.lang.StringBuffer);;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(java.lang.StringBuffer,int,int);;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(java.lang.String,int,int);;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(org.apache.commons.lang3.text.StrBuilder,int,int);;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(java.lang.Object,java.util.Map);;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(java.lang.Object,java.util.Map,java.lang.String,java.lang.String);;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(java.lang.Object,java.util.Map,java.lang.String,java.lang.String);;Argument[1];ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replace;(java.lang.Object,java.util.Properties);;Argument;ReturnValue;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;setVariableResolver;;;Argument;Argument[-1];taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replaceIn;(org.apache.commons.lang3.text.StrBuilder);;Argument[-1];Argument;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replaceIn;(java.lang.StringBuffer);;Argument[-1];Argument;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replaceIn;(java.lang.StringBuffer,int,int);;Argument[-1];Argument[0];taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replaceIn;(java.lang.StringBuilder);;Argument[-1];Argument;taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replaceIn;(java.lang.StringBuilder,int,int);;Argument[-1];Argument[0];taint",
        "org.apache.commons.lang3.text;StrSubstitutor;false;replaceIn;(org.apache.commons.lang3.text.StrBuilder,int,int);;Argument[-1];Argument[0];taint",
        "org.apache.commons.text;StringSubstitutor;false;StringSubstitutor;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;;;Argument[-1];ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(java.lang.Object);;Argument;ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(char[]);;Argument;ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(char[],int,int);;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(java.lang.CharSequence);;Argument;ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(java.lang.CharSequence,int,int);;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(java.lang.String);;Argument;ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(java.lang.StringBuffer);;Argument;ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(java.lang.StringBuffer,int,int);;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(java.lang.String,int,int);;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(java.lang.Object,java.util.Map);;Argument;ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(java.lang.Object,java.util.Map,java.lang.String,java.lang.String);;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(java.lang.Object,java.util.Map,java.lang.String,java.lang.String);;Argument[1];ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(java.lang.Object,java.util.Properties);;Argument;ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(org.apache.commons.text.TextStringBuilder);;Argument;ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;replace;(org.apache.commons.text.TextStringBuilder,int,int);;Argument[0];ReturnValue;taint",
        "org.apache.commons.text;StringSubstitutor;false;setVariableResolver;;;Argument;Argument[-1];taint",
        "org.apache.commons.text;StringSubstitutor;false;replaceIn;(java.lang.StringBuffer);;Argument[-1];Argument;taint",
        "org.apache.commons.text;StringSubstitutor;false;replaceIn;(java.lang.StringBuffer,int,int);;Argument[-1];Argument[0];taint",
        "org.apache.commons.text;StringSubstitutor;false;replaceIn;(java.lang.StringBuilder);;Argument[-1];Argument;taint",
        "org.apache.commons.text;StringSubstitutor;false;replaceIn;(java.lang.StringBuilder,int,int);;Argument[-1];Argument[0];taint",
        "org.apache.commons.text;StringSubstitutor;false;replaceIn;(org.apache.commons.text.TextStringBuilder);;Argument[-1];Argument;taint",
        "org.apache.commons.text;StringSubstitutor;false;replaceIn;(org.apache.commons.text.TextStringBuilder,int,int);;Argument[-1];Argument[0];taint"
      ]
  }
}

/**
 * Taint-propagating models for `RegexUtils`.
 */
private class ApacheRegExUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.lang3;RegExUtils;false;removeAll;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3;RegExUtils;false;removeFirst;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3;RegExUtils;false;removePattern;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3;RegExUtils;false;replaceAll;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3;RegExUtils;false;replaceFirst;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3;RegExUtils;false;replacePattern;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.lang3;RegExUtils;false;replaceAll;;;Argument[2];ReturnValue;taint",
        "org.apache.commons.lang3;RegExUtils;false;replaceFirst;;;Argument[2];ReturnValue;taint",
        "org.apache.commons.lang3;RegExUtils;false;replacePattern;;;Argument[2];ReturnValue;taint"
      ]
  }
}

/**
 * Taint-propagating models for `ObjectUtils`.
 */
private class ApacheObjectUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        // Note all the functions annotated with `taint` flow really should have `value` flow,
        // but we don't support value-preserving varargs functions at the moment.
        "org.apache.commons.lang3;ObjectUtils;false;clone;;;Argument;ReturnValue;value",
        "org.apache.commons.lang3;ObjectUtils;false;cloneIfPossible;;;Argument;ReturnValue;value",
        "org.apache.commons.lang3;ObjectUtils;false;CONST;;;Argument;ReturnValue;value",
        "org.apache.commons.lang3;ObjectUtils;false;CONST_BYTE;;;Argument;ReturnValue;value",
        "org.apache.commons.lang3;ObjectUtils;false;CONST_SHORT;;;Argument;ReturnValue;value",
        "org.apache.commons.lang3;ObjectUtils;false;defaultIfNull;;;Argument;ReturnValue;value",
        "org.apache.commons.lang3;ObjectUtils;false;firstNonNull;;;Argument;ReturnValue;taint",
        "org.apache.commons.lang3;ObjectUtils;false;getIfNull;;;Argument[0];ReturnValue;value",
        "org.apache.commons.lang3;ObjectUtils;false;max;;;Argument;ReturnValue;taint",
        "org.apache.commons.lang3;ObjectUtils;false;median;;;Argument;ReturnValue;taint",
        "org.apache.commons.lang3;ObjectUtils;false;min;;;Argument;ReturnValue;taint",
        "org.apache.commons.lang3;ObjectUtils;false;mode;;;Argument;ReturnValue;taint",
        "org.apache.commons.lang3;ObjectUtils;false;requireNonEmpty;;;Argument[0];ReturnValue;value",
        "org.apache.commons.lang3;ObjectUtils;false;toString;(Object,String);;Argument[1];ReturnValue;value"
      ]
  }
}
