/** Provides classes and predicates related to the Stapler framework. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.TypeFlow
private import semmle.code.java.frameworks.hudson.Hudson
private import semmle.code.java.frameworks.JavaxAnnotations

/**
 * A callable annotated with a Stapler `DataBound` annotation,
 * or that has the `@stapler-constructor` Javadoc annotation.
 */
class DataBoundAnnotated extends Callable {
  DataBoundAnnotated() {
    exists(Annotation an |
      an.getType()
          .hasQualifiedName("org.kohsuke.stapler", ["DataBoundConstructor", "DataBoundSetter"])
    |
      this = an.getAnnotatedElement()
    )
    or
    exists(Javadoc doc | doc.getAChild().getText().matches("%@stapler-constructor%") |
      doc.getCommentedElement() = this
    )
  }
}

/** The interface `org.kohsuke.stapler.HttpResponse`. */
class HttpResponse extends Interface {
  HttpResponse() { this.hasQualifiedName("org.kohsuke.stapler", "HttpResponse") }
}

/**
 * A remote flow source for parameters annotated with an annotation
 * that is itself annotated with `InjectedParameter`.
 *
 * Such parameters are populated with user-provided data by Stapler.
 */
private class InjectedParameterSource extends RemoteFlowSource {
  InjectedParameterSource() {
    this.asParameter().getAnAnnotation().getType() instanceof InjectedParameterAnnotatedType
  }

  override string getSourceType() { result = "Stapler injected parameter" }
}

/**
 * A dataflow step from the `HttpResponse` return value of a `HudsonWebMethod`
 * to the instance parameter of the `generateResponse` method of the appropriate subtype of `HttpResponse`.
 *
 * This models the rendering process of an `HttpResponse` by Stapler.
 */
private class HttpResponseGetDescriptionStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(ReturnStmt s, GenerateResponseMethod m |
      s.getEnclosingCallable() instanceof HudsonWebMethod and
      boundOrStaticType(s.getResult(), m.getDeclaringType().getADescendant())
    |
      n1.asExpr() = s.getResult() and
      n2.(DataFlow::InstanceParameterNode).getCallable() = m
    )
  }
}

/**
 * A dataflow step from the post-update node of an instance access in a `DataBoundAnnotated` method
 * to the instance parameter of a `PostConstruct` method of the same type.
 *
 * This models the construction process of a `DataBound` object in Stapler.
 */
private class PostConstructDataBoundAdditionalStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(PostConstructDataBoundMethod postConstruct, DataBoundAnnotated input |
      postConstruct.getDeclaringType() = input.getDeclaringType()
    |
      n1.(DataFlow::PostUpdateNode)
          .getPreUpdateNode()
          .(DataFlow::InstanceAccessNode)
          .getEnclosingCallable() = input and
      n2.(DataFlow::InstanceParameterNode).getCallable() = postConstruct
    )
  }
}

/** An annotation type annotated with the `InjectedParameter` annotation. */
private class InjectedParameterAnnotatedType extends AnnotationType {
  InjectedParameterAnnotatedType() {
    this.getAnAnnotation().getType().hasQualifiedName("org.kohsuke.stapler", "InjectedParameter")
  }
}

/** The `generateResponse` method of `org.kohsuke.stapler.HttpResponse` or its subtypes. */
private class GenerateResponseMethod extends Method {
  GenerateResponseMethod() {
    this.getDeclaringType().getASourceSupertype*() instanceof HttpResponse and
    this.hasName("generateResponse")
  }
}

/** Holds if `t` is the static type of `e`, or an upper bound of the runtime type of `e`. */
private predicate boundOrStaticType(Expr e, RefType t) {
  exprTypeFlow(e, t, false)
  or
  t = e.getType()
}

/**
 * A method called after the construction of a `DataBound` object.
 *
 * That is, either the `bindResolve` method of a subtype of `org.kohsuke.stapler.DataBoundResolvable`,
 * or a method annotated with `javax.annotation.PostConstruct`.
 */
private class PostConstructDataBoundMethod extends Method {
  PostConstructDataBoundMethod() {
    this.getDeclaringType()
        .getASourceSupertype*()
        .hasQualifiedName("org.kohsuke.stapler", "DataBoundResolvable") and
    this.hasName("bindResolve")
    or
    this.getAnAnnotation() instanceof PostConstructAnnotation
  }
}
