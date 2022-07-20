/**
 * @name Capture summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @kind diagnostic
 * @id cs/utils/model-generator/summary-models
 * @tags model-generator
 */

private import semmle.code.csharp.dataflow.ExternalFlow
private import internal.CaptureModels
private import internal.CaptureSummaryFlow

/*
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
 * ```Summaries;BasicFlow;false;ReturnThis;(System.Object);;Argument[Qualifier];ReturnValue;value;generated```
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
 * Summaries;BasicFlow;false;ReturnField;();;Argument[Qualifier].SyntheticField[Summaries.BasicFlow.tainted];ReturnValue;value;generated |
 * Summaries;CollectionFlow;false;AssignToArray;(System.Object,System.Object[]);;Argument[0];Argument[1].Element;value;generated
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
 * ```Summaries;BasicFlow;false;SetField;(System.String);;Argument[0];Argument[Qualifier].SyntheticField[Summaries.BasicFlow.tainted];value;generated```
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
 * ```Summaries;BasicFlow;false;ReturnSubstring;(System.String);;Argument[0];ReturnValue;taint;generated```
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
 * ```Summaries;CollectionFlow;false;AssignToArray;(System.Object,System.Object[]);;Argument[0];Argument[1].Element;value;generated```
 */

from TargetApi api, string flow
where flow = captureThroughFlow(api) and not hasSummary(api, false)
select flow order by flow
