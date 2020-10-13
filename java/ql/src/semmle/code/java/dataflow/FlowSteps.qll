/**
 * Provides classes representing various flow steps for taint tracking.
 */

private import java
private import semmle.code.java.dataflow.DataFlow

/**
 * A module importing the frameworks that implement additional flow steps,
 * ensuring that they are visible to the taint tracking library.
 */
module Frameworks {
  private import semmle.code.java.frameworks.jackson.JacksonSerializability
  private import semmle.code.java.frameworks.android.Intent
  private import semmle.code.java.frameworks.android.SQLite
  private import semmle.code.java.frameworks.Guice
  private import semmle.code.java.frameworks.Protobuf
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to all
 * taint configurations.
 */
class AdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for all configurations.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/**
 * A method or constructor that preserves taint.
 *
 * Extend this class and override at least one of `returnsTaintFrom` or `transfersTaint`
 * to add additional taint steps through a method that should apply to all taint configurations.
 */
abstract class TaintPreservingCallable extends Callable {
  /**
   * Holds if this callable returns tainted data when `arg` tainted.
   * `arg` is a parameter index, or is -1 to indicate the qualifier.
   */
  predicate returnsTaintFrom(int arg) { none() }

  /**
   * Holds if this callable writes tainted data to `sink` when `src` is tainted.
   * `src` and `sink` are parameter indices, or -1 to indicate the qualifier.
   */
  predicate transfersTaint(int src, int sink) { none() }
}

private class StringTaintPreservingMethod extends TaintPreservingCallable {
  StringTaintPreservingMethod() {
    this.getDeclaringType() instanceof TypeString and
    this
        .hasName(["concat", "copyValueOf", "endsWith", "format", "formatted", "getBytes", "indent",
              "intern", "join", "repeat", "split", "strip", "stripIndent", "stripLeading",
              "stripTrailing", "substring", "toCharArray", "toLowerCase", "toString", "toUpperCase",
              "trim"])
  }

  override predicate returnsTaintFrom(int arg) {
    arg = -1 and not this.isStatic()
    or
    this.hasName(["concat", "copyValueOf"]) and arg = 0
    or
    this.hasName(["format", "formatted", "join"]) and arg = [0 .. getNumberOfParameters()]
  }
}

private class StringTaintPreservingConstructor extends Constructor, TaintPreservingCallable {
  StringTaintPreservingConstructor() { this.getDeclaringType() instanceof TypeString }

  override predicate returnsTaintFrom(int arg) { arg = 0 }
}

private class NumberTaintPreservingCallable extends TaintPreservingCallable {
  int argument;

  NumberTaintPreservingCallable() {
    this.getDeclaringType().getASupertype*().hasQualifiedName("java.lang", "Number") and
    (
      this instanceof Constructor and
      argument = 0
      or
      this.getName().matches(["to%String", "toByteArray", "%Value"]) and
      argument = -1
      or
      this.getName().matches(["parse%", "valueOf%", "to%String", "decode"]) and
      argument = 0
    )
  }

  override predicate returnsTaintFrom(int arg) { arg = argument }
}

/** Holds for the types `StringBuilder`, `StringBuffer`, and `StringWriter`. */
private predicate stringBuilderType(RefType t) {
  t.hasQualifiedName("java.lang", "StringBuilder") or
  t.hasQualifiedName("java.lang", "StringBuffer") or
  t.hasQualifiedName("java.io", "StringWriter")
}

private class StringBuilderTaintPreservingCallable extends TaintPreservingCallable {
  StringBuilderTaintPreservingCallable() {
    exists(Method m |
      this.(Method).overrides*(m) and
      stringBuilderType(m.getDeclaringType()) and
      m.hasName(["append", "insert", "replace", "toString", "write"])
    )
    or
    this.(Constructor).getParameterType(0) instanceof RefType and
    stringBuilderType(this.getDeclaringType())
  }

  override predicate returnsTaintFrom(int arg) {
    arg = -1 and
    not this instanceof Constructor
    or
    this instanceof Constructor and arg = 0
    or
    this.hasName("append") and arg = 0
    or
    this.hasName("insert") and arg = 1
    or
    this.hasName("replace") and arg = 2
  }

  override predicate transfersTaint(int src, int sink) {
    returnsTaintFrom(src) and
    sink = -1 and
    src != -1 and
    not this instanceof Constructor
    or
    this.hasName("write") and
    src = 0 and
    sink = -1
  }
}
