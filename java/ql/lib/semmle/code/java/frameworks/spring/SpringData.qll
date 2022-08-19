/**
 * Provides classes and predicates for working with Spring classes and interfaces from
 * `org.springframework.data`.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

/**
 * Provides models for the `org.springframework.data` package.
 */
private class FlowSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.springframework.data.repository;CrudRepository;true;save;;;Argument[0];ReturnValue;value;manual"
      ]
  }
}
