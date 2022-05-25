/**
 * @name Capture summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @id java/utils/model-generator/summary-models
 */

private import internal.CaptureModels

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
 * p;Foo;true;returnsTainted;;Argument[-1];ReturnValue;taint
 * p;Foo;true;putsTaintIntoParameter;(List);Argument[-1];Argument[0];taint
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
 * ```p;Foo;true;doSomething;(String);Argument[0];Argument[-1];taint```
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
string captureFlow(TargetApi api) {
  result = captureQualifierFlow(api) or
  result = captureThroughFlow(api)
}

from TargetApi api, string flow
where flow = captureFlow(api)
select flow order by flow
