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
