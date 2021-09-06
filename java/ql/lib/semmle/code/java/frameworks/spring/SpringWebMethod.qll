/** Provides models of taint flow in `org.springframework.web.method` */

import java
private import semmle.code.java.dataflow.ExternalFlow

// currently only models classes in the `support` subpackage
private class FlowSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        // for review: arguably this shouldn't be modeled as the implementations of resolveArgument that I've seen are effectively sanitized
        "org.springframework.web.method.support;HandlerMethodArgumentResolver;true;resolveArgument;;;Argument[2];ReturnValue;taint",
        "org.springframework.web.method.support;UriComponentsContributor;true;contributeMethodArgument;;;Argument[1];Argument[2];taint",
        "org.springframework.web.method.support;UriComponentsContributor;true;contributeMethodArgument;;;Argument[1];Argument[3];taint",
        // InvocableHandlerMethod is not modeled as it is difficult to model method-like classes with CSV
        // This is a very broad definition of data flow; there is a method `setRedirectModelScenario(boolean)` which is used to determine which of the `Default` and `Redirect` models are returned by `getModel`, and the methods that deal with attributes below are convenience methods for `.getModel().*`.
        "org.springframework.web.method.support;ModelAndViewContainer;false;getModel;;;SyntheticField[org.springframework.web.method.support.ModelAndViewContainer.Model] of Argument[-1];ReturnValue;value",
        "org.springframework.web.method.support;ModelAndViewContainer;false;getDefaultModel;;;SyntheticField[org.springframework.web.method.support.ModelAndViewContainer.Model] of Argument[-1];ReturnValue;value",
        "org.springframework.web.method.support;ModelAndViewContainer;false;setRedirectModel;;;Argument[0];SyntheticField[org.springframework.web.method.support.ModelAndViewContainer.Model] of Argument[-1];value",
        "org.springframework.web.method.support;ModelAndViewContainer;false;addAttribute;;;Argument[0];MapKey of SyntheticField[org.springframework.web.method.support.ModelAndViewContainer.Model] of Argument[-1];value",
        "org.springframework.web.method.support;ModelAndViewContainer;false;addAttribute;;;Argument[1];MapValue of SyntheticField[org.springframework.web.method.support.ModelAndViewContainer.Model] of Argument[-1];value",
        "org.springframework.web.method.support;ModelAndViewContainer;false;addAllAttributes;;;MapKey of Argument[0];MapKey of SyntheticField[org.springframework.web.method.support.ModelAndViewContainer.Model] of Argument[-1];value",
        "org.springframework.web.method.support;ModelAndViewContainer;false;addAllAttributes;;;MapValue of Argument[0];MapValue of SyntheticField[org.springframework.web.method.support.ModelAndViewContainer.Model] of Argument[-1];value",
        "org.springframework.web.method.support;ModelAndViewContainer;false;mergeAttributes;;;MapKey of Argument[0];MapKey of SyntheticField[org.springframework.web.method.support.ModelAndViewContainer.Model] of Argument[-1];value",
        "org.springframework.web.method.support;ModelAndViewContainer;false;mergeAttributes;;;MapValue of Argument[0];MapValue of SyntheticField[org.springframework.web.method.support.ModelAndViewContainer.Model] of Argument[-1];value",
        "org.springframework.web.method.support;ModelAndViewContainer;false;setView;;;Argument[0];SyntheticField[org.springframework.web.method.support.ModelAndViewContainer.View] of Argument[-1];value",
        "org.springframework.web.method.support;ModelAndViewContainer;false;getView;;;SyntheticField[org.springframework.web.method.support.ModelAndViewContainer.View] of Argument[-1];ReturnValue;value"
      ]
  }
}
