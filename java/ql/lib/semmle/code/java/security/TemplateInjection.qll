/** Definitions related to the server-side template injection (SST) query. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.TaintTracking

/**
 * A source for server-side template injection (SST) vulnerabilities.
 */
abstract class TemplateInjectionSource extends DataFlow::Node {
  /** Holds if this source has the specified `state`. */
  predicate hasState(DataFlow::FlowState state) { state instanceof DataFlow::FlowStateEmpty }
}

/**
 * A sink for server-side template injection (SST) vulnerabilities.
 */
abstract class TemplateInjectionSink extends DataFlow::Node {
  /** Holds if this sink has the specified `state`. */
  predicate hasState(DataFlow::FlowState state) { state instanceof DataFlow::FlowStateEmpty }
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to flows related to
 * server-side template injection (SST) vulnerabilities.
 */
class TemplateInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for flows related to server-side template injection (SST) vulnerabilities.
   */
  predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) { none() }

  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for flows related toserver-side template injection (SST) vulnerabilities.
   * This step is only applicable in `state1` and updates the flow state to `state2`.
   */
  predicate isAdditionalTaintStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    none()
  }
}

/**
 * A sanitizer for server-side template injection (SST) vulnerabilities.
 */
abstract class TemplateInjectionSanitizer extends DataFlow::Node { }

/**
 * A sanitizer for server-side template injection (SST) vulnerabilities.
 * This sanitizer is only applicable when `TemplateInjectionSanitizerWithState::hasState`
 * holds for the flow state.
 */
abstract class TemplateInjectionSanitizerWithState extends DataFlow::Node {
  /** Holds if this sanitizer has the specified `state`. */
  abstract predicate hasState(DataFlow::FlowState state);
}

private class DefaultTemplateInjectionSource extends TemplateInjectionSource instanceof RemoteFlowSource {
}

private class DefaultTemplateInjectionSink extends TemplateInjectionSink {
  DefaultTemplateInjectionSink() { sinkNode(this, "ssti") }
}

private class DefaultTemplateInjectionSanitizer extends TemplateInjectionSanitizer {
  DefaultTemplateInjectionSanitizer() {
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof BoxedType or
    this.getType() instanceof NumericType
  }
}

private class TemplateInjectionSinkModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "freemarker.template;Template;true;Template;(String,Reader);;Argument[1];ssti;manual",
        "freemarker.template;Template;true;Template;(String,Reader,Configuration);;Argument[1];ssti;manual",
        "freemarker.template;Template;true;Template;(String,Reader,Configuration,String);;Argument[1];ssti;manual",
        "freemarker.template;Template;true;Template;(String,String,Reader,Configuration);;Argument[2];ssti;manual",
        "freemarker.template;Template;true;Template;(String,String,Reader,Configuration,String);;Argument[2];ssti;manual",
        "freemarker.template;Template;true;Template;(String,String,Reader,Configuration,ParserConfiguration,String);;Argument[2];ssti;manual",
        "freemarker.template;Template;true;Template;(String,String,Configuration);;Argument[1];ssti;manual",
        "freemarker.cache;StringTemplateLoader;true;putTemplate;;;Argument[1];ssti;manual",
        "com.mitchellbosecke.pebble;PebbleEngine;true;getTemplate;;;Argument[0];ssti;manual",
        "com.mitchellbosecke.pebble;PebbleEngine;true;getLiteralTemplate;;;Argument[0];ssti;manual",
        "com.hubspot.jinjava;Jinjava;true;renderForResult;;;Argument[0];ssti;manual",
        "com.hubspot.jinjava;Jinjava;true;render;;;Argument[0];ssti;manual",
        "org.thymeleaf;ITemplateEngine;true;process;;;Argument[0];ssti;manual",
        "org.thymeleaf;ITemplateEngine;true;processThrottled;;;Argument[0];ssti;manual",
        "org.apache.velocity.app;Velocity;true;evaluate;;;Argument[3];ssti;manual",
        "org.apache.velocity.app;Velocity;true;mergeTemplate;;;Argument[2];ssti;manual",
        "org.apache.velocity.app;VelocityEngine;true;evaluate;;;Argument[3];ssti;manual",
        "org.apache.velocity.app;VelocityEngine;true;mergeTemplate;;;Argument[2];ssti;manual",
        "org.apache.velocity.runtime.resource.util;StringResourceRepository;true;putStringResource;;;Argument[1];ssti;manual",
        "org.apache.velocity.runtime;RuntimeServices;true;evaluate;;;Argument[3];ssti;manual",
        "org.apache.velocity.runtime;RuntimeServices;true;parse;;;Argument[0];ssti;manual",
        "org.apache.velocity.runtime;RuntimeSingleton;true;parse;;;Argument[0];ssti;manual"
      ]
  }
}
