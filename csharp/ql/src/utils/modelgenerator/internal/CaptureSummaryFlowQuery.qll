private import CaptureModels

/**
 * Capture fluent APIs that return `this`.
 * Example of a fluent API:
 * ```csharp
 * public class BasicFlow {
 *   public BasicFlow ReturnThis(object input)
 *   {
 *     // some side effect
 *     return this;
 *   }
 * ```
 * Captured Model:
 * ```Summaries;BasicFlow;false;ReturnThis;(System.Object);Argument[this];ReturnValue;value```
 * Capture APIs that transfer taint from an input parameter to an output return
 * value or parameter.
 * Allows a sequence of read steps followed by a sequence of store steps.
 *
 * Examples:
 *
 * ```csharp
 * public class BasicFlow {
 *   private string tainted;
 *
 *   public String ReturnField()
 *   {
 *     return tainted;
 *   }
 *
 *   public void AssignFieldToArray(object[] target)
 *   {
 *     target[0] = tainted;
 *   }
 * }
 * ```
 * Captured Models:
 * ```
 * Summaries;BasicFlow;false;ReturnField;();Argument[this];ReturnValue;taint |
 * Summaries;BasicFlow;false;AssignFieldToArray;(System.Object[]);Argument[this];Argument[0].Element;taint
 * ```
 *
 * ```csharp
 * public class BasicFlow {
 *   private string tainted;
 *
 *   public void SetField(string s)
 *   {
 *     tainted = s;
 *   }
 * }
 * ```
 * Captured Model:
 * ```Summaries;BasicFlow;false;SetField;(System.String);Argument[0];Argument[this];taint```
 *
 * ```csharp
 * public class BasicFlow {
 *   public void ReturnSubstring(string s)
 *   {
 *     return s.Substring(0, 1);
 *   }
 * }
 * ```
 * Captured Model:
 * ```Summaries;BasicFlow;false;ReturnSubstring;(System.String);Argument[0];ReturnValue;taint```
 *
 * ```csharp
 * public class BasicFlow {
 *    public void AssignToArray(int data, int[] target)
 *    {
 *        target[0] = data;
 *    }
 * }
 * ```
 * Captured Model:
 * ```Summaries;BasicFlow;false;AssignToArray;(System.Int32,System.Int32[]);Argument[0];Argument[1].Element;taint```
 */
string captureFlow(DataFlowTargetApi api) {
  result = captureQualifierFlow(api) or
  result = captureThroughFlow(api)
}

/**
 * Gets the neutral model for `api`, if any.
 * A neutral model is generated, if there does not exist summary model.
 */
string captureNoFlow(DataFlowTargetApi api) {
  not exists(captureFlow(api)) and
  result = asNeutralModel(api)
}
