/** Provides classes and predicates related to the Hudson framework. */
overlay[local?]
module;

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.frameworks.stapler.Stapler
private import semmle.code.java.security.XSS

/** A method declared in a subtype of `hudson.model.Descriptor` that returns an `HttpResponse`. */
class HudsonWebMethod extends Method {
  HudsonWebMethod() {
    this.getReturnType().(RefType).getASourceSupertype*() instanceof HttpResponse and
    this.getDeclaringType().getASourceSupertype*().hasQualifiedName("hudson.model", "Descriptor")
  }
}
