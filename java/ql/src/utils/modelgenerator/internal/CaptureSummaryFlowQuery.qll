private import CaptureModels

/**
 * Capture fluent APIs that return `this`.
 * Example of a fluent API:
 * ```java
 * public class Foo {
 *   public Foo someAPI() {
 *    // some side-effect
 *    return this;
 *  }
 * }
 * ```
 *
 * Capture APIs that transfer taint from an input parameter to an output return
 * value or parameter.
 * Allows a sequence of read steps followed by a sequence of store steps.
 *
 * Examples:
 *
 * ```java
 * public class Foo {
 *   private String tainted;
 *
 *   public String returnsTainted() {
 *     return tainted;
 *   }
 *
 *   public void putsTaintIntoParameter(List<String> foo) {
 *     foo.add(tainted);
 *   }
 * }
 * ```
 * Captured Models:
 * ```
 * p;Foo;true;returnsTainted;;Argument[this];ReturnValue;taint;df-generated
 * p;Foo;true;putsTaintIntoParameter;(List);Argument[this];Argument[0];taint;df-generated
 * ```
 *
 * ```java
 * public class Foo {
 *  private String tainted;
 *  public void doSomething(String input) {
 *    tainted = input;
 *  }
 * ```
 * Captured Model:
 * ```p;Foo;true;doSomething;(String);Argument[0];Argument[this];taint;df-generated```
 *
 * ```java
 * public class Foo {
 *   public String returnData(String tainted) {
 *     return tainted.substring(0,10)
 *   }
 * }
 * ```
 * Captured Model:
 * ```p;Foo;true;returnData;;Argument[0];ReturnValue;taint;df-generated```
 *
 * ```java
 * public class Foo {
 *   public void addToList(String tainted, List<String> foo) {
 *     foo.add(tainted);
 *   }
 * }
 * ```
 * Captured Model:
 * ```p;Foo;true;addToList;;Argument[0];Argument[1];taint;df-generated```
 */
string captureFlow(DataFlowSummaryTargetApi api) {
  result = captureQualifierFlow(api) or
  result = captureThroughFlow(api)
}

/**
 * Gets the neutral summary model for `api`, if any.
 * A neutral summary model is generated, if we are not generating
 * a summary model that applies to `api`.
 */
string captureNoFlow(DataFlowSummaryTargetApi api) {
  not exists(DataFlowSummaryTargetApi api0 | exists(captureFlow(api0)) and api0.lift() = api.lift()) and
  api.isRelevant() and
  result = Printing::asNeutralSummaryModel(api)
}
