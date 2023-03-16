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
 * p;Foo;true;returnsTainted;;Argument[this];ReturnValue;taint
 * p;Foo;true;putsTaintIntoParameter;(List);Argument[this];Argument[0];taint
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
 * ```p;Foo;true;doSomething;(String);Argument[0];Argument[this];taint```
 *
 * ```java
 * public class Foo {
 *   public String returnData(String tainted) {
 *     return tainted.substring(0,10)
 *   }
 * }
 * ```
 * Captured Model:
 * ```p;Foo;true;returnData;;Argument[0];ReturnValue;taint```
 *
 * ```java
 * public class Foo {
 *   public void addToList(String tainted, List<String> foo) {
 *     foo.add(tainted);
 *   }
 * }
 * ```
 * Captured Model:
 * ```p;Foo;true;addToList;;Argument[0];Argument[1];taint```
 */
string captureFlow(DataFlowTargetApi api) {
  result = captureQualifierFlow(api) or
  result = captureThroughFlow(api)
}

/**
 * Gets the neutral summary for `api`, if any.
 * A neutral model is generated, if there does not exist any summary model.
 */
string captureNoFlow(DataFlowTargetApi api) {
  not exists(captureFlow(api)) and
  result = asNeutralModel(api)
}
