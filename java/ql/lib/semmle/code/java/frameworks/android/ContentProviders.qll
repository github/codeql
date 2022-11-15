/**
 * Provides classes and predicates for working with Content Providers.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

/** The class `android.content.ContentValues`. */
class ContentValues extends Class {
  ContentValues() { this.hasQualifiedName("android.content", "ContentValues") }
}
