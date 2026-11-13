/*
 * This should be QLDoc.
 */

/**
 * this is fine
 */
predicate foo() { any() }

/* Note: this is bad. */
class Foo extends string {
  Foo() { this = "FOo" }
}

/**
 * This is also fine.
 */
/*abstract*/ class Bar extends string {
  string getMergeRaw() { none() } // <- fine. The abstract comment is fine, it doesn't need to be QLDoc.

  Bar() { this = "bar" }
}
