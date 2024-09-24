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
 * ```Summaries;BasicFlow;false;ReturnThis;(System.Object);Argument[this];ReturnValue;value;df-generated```
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
 * Summaries;BasicFlow;false;ReturnField;();Argument[this];ReturnValue;taint;df-generated |
 * Summaries;BasicFlow;false;AssignFieldToArray;(System.Object[]);Argument[this];Argument[0].Element;taint;df-generated
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
 * ```Summaries;BasicFlow;false;SetField;(System.String);Argument[0];Argument[this];taint;df-generated```
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
 * ```Summaries;BasicFlow;false;ReturnSubstring;(System.String);Argument[0];ReturnValue;taint;df-generated```
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
 * ```Summaries;BasicFlow;false;AssignToArray;(System.Int32,System.Int32[]);Argument[0];Argument[1].Element;taint;df-generated```
 */
string captureFlow(DataFlowSummaryTargetApi api) {
  result = captureQualifierFlow(api) or
  result = captureThroughFlow(api)
}

/**
 * Gets the neutral summary model for `api`, if any.
 * A neutral summary model is generated, if we are not generating
 * a summary model that applies to `api` and if it relevant to generate
 * a model for `api`.
 */
string captureNoFlow(DataFlowSummaryTargetApi api) {
  not exists(DataFlowSummaryTargetApi api0 | exists(captureFlow(api0)) and api0.lift() = api.lift()) and
  api.isRelevant() and
  result = Printing::asNeutralSummaryModel(api)
}
