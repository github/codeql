/**
 * Provides classes and predicates for working with the Thymeleaf template engine.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class ThymeleafSummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.thymeleaf;TemplateSpec;false;TemplateSpec;;;Argument[0];Argument[-1];taint;manual",
        "org.thymeleaf;TemplateSpec;false;getTemplate;;;Argument[-1];ReturnValue;taint;manual",
      ]
  }
}
