/**
 * Provides classes and predicates for working with Content Providers.
 */

import java
import semmle.code.java.dataflow.ExternalFlow

/** The class `android.content.ContentValues`. */
class ContentValues extends Class {
  ContentValues() { this.hasQualifiedName("android.content", "ContentValues") }
}

private class SummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.content;ContentValues;false;put;;;Argument[0];MapKey of Argument[-1];value",
        "android.content;ContentValues;false;put;;;Argument[1];MapValue of Argument[-1];value",
        "android.content;ContentValues;false;putAll;;;MapKey of Argument[0];MapKey of Argument[-1];value",
        "android.content;ContentValues;false;putAll;;;MapValue of Argument[0];MapValue of Argument[-1];value"
      ]
  }
}
