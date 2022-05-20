/** Definitions of flow steps through utility methods of `org.springframework.validation.Errors`. */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class SpringValidationErrorModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.springframework.validation;Errors;true;addAllErrors;;;Argument[0];Argument[-1];taint",
        "org.springframework.validation;Errors;true;getAllErrors;;;Argument[-1];ReturnValue;taint",
        "org.springframework.validation;Errors;true;getFieldError;;;Argument[-1];ReturnValue;taint",
        "org.springframework.validation;Errors;true;getFieldErrors;;;Argument[-1];ReturnValue;taint",
        "org.springframework.validation;Errors;true;getGlobalError;;;Argument[-1];ReturnValue;taint",
        "org.springframework.validation;Errors;true;getGlobalErrors;;;Argument[-1];ReturnValue;taint",
        "org.springframework.validation;Errors;true;reject;;;Argument[0];Argument[-1];taint",
        "org.springframework.validation;Errors;true;reject;;;Argument[1].ArrayElement;Argument[-1];taint",
        "org.springframework.validation;Errors;true;reject;;;Argument[2];Argument[-1];taint",
        "org.springframework.validation;Errors;true;rejectValue;;;Argument[1];Argument[-1];taint",
        "org.springframework.validation;Errors;true;rejectValue;;;Argument[3];Argument[-1];taint",
        "org.springframework.validation;Errors;true;rejectValue;(java.lang.String,java.lang.String,java.lang.Object[],java.lang.String);;Argument[2].ArrayElement;Argument[-1];taint",
        "org.springframework.validation;Errors;true;rejectValue;(java.lang.String,java.lang.String,java.lang.String);;Argument[2];Argument[-1];taint"
      ]
  }
}
