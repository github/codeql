/**
 * @name Abusing Angular2's ElementRef nativeElement property
 * @description Passing user input into Angular2's ElementRef nativeElement property can cause code injection.
 * @kind path-problem
 * @problem.severity error
 * @id js/angular-js/native-element-code-injection
 * @tags security
 *       external/cwe/cwe-094
 * @precision low
 */

import javascript
import semmle.javascript.frameworks.Angular2

class AngularNativeElementInjectionConfiguration extends DataFlow::Configuration {
  AngularNativeElementInjectionConfiguration() {
    this = "AngularNativeElementInjectionConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    // I am having a REAL hard time identifying sources in Angular 2. For now this predicate
    // doesn't work.
    source instanceof DataFlow::Node and
    not (
      source.(DataFlow::FunctionNode).getCalleeName() = "sanitize" and
      // I understand that this is similar to Angular2#domSanitizer(), however in VSCode the query
      // can't identify the Angular2 module. For now I've left importing the Angular2 module. I will
      // resolve this before the PR is merged in.
      source
          .(DataFlow::MethodCallNode)
          .getReceiver()
          .hasUnderlyingType("@angular/core", "DomSanitizer")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    sink.(DataFlow::PropRead).getPropertyName() = "nativeElement" and
    exists(sink.(DataFlow::PropRead).getALocalSource().getAPropertyRead*().getAPropertyWrite*())
  }
}

from AngularNativeElementInjectionConfiguration dataflow, DataFlow::Node source, DataFlow::Node sink
where dataflow.hasFlow(source, sink)
select sink.getNode(), source, sink,
  "$@ flows to " + sink.getNode().(Sink).getMessageSuffix() + ".", source.getNode(),
  "User-provided value"
