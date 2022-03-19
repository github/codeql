/** Provides definitions related to the namespace `System.Diagnostics`. */

import semmle.code.csharp.Type
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.dataflow.ExternalFlow

/** The `System.Diagnostics` namespace. */
class SystemDiagnosticsNamespace extends Namespace {
  SystemDiagnosticsNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Diagnostics")
  }
}

/** The `System.Diagnostics.CodeAnalysis` namespace. */
class SystemDiagnosticsCodeAnalysisNamespace extends Namespace {
  SystemDiagnosticsCodeAnalysisNamespace() {
    this.getParentNamespace() instanceof SystemDiagnosticsNamespace and
    this.hasName("CodeAnalysis")
  }
}

/** A class in the `System.Diagnostics` namespace. */
class SystemDiagnosticsClass extends Class {
  SystemDiagnosticsClass() { this.getNamespace() instanceof SystemDiagnosticsNamespace }
}

/** A class in the `System.Diagnostics.CodeAnalysis` namespace. */
class SystemDiagnosticsCodeAnalysisClass extends Class {
  SystemDiagnosticsCodeAnalysisClass() {
    this.getNamespace() instanceof SystemDiagnosticsCodeAnalysisNamespace
  }
}

/** The `System.Diagnostics.Debug` class. */
class SystemDiagnosticsDebugClass extends SystemDiagnosticsClass {
  SystemDiagnosticsDebugClass() {
    this.hasName("Debug") and
    this.isStatic()
  }

  /** Gets an `Assert(bool, ...)` method. */
  Method getAssertMethod() {
    result.getDeclaringType() = this and
    result.hasName("Assert") and
    result.getParameter(0).getType() instanceof BoolType and
    result.getReturnType() instanceof VoidType
  }
}

/** The `System.Diagnostics.ProcessStartInfo` class. */
class SystemDiagnosticsProcessStartInfoClass extends SystemDiagnosticsClass {
  SystemDiagnosticsProcessStartInfoClass() { this.hasName("ProcessStartInfo") }

  /** Gets the `Arguments` property. */
  Property getArgumentsProperty() { result = this.getProperty("Arguments") }

  /** Gets the `FileName` property. */
  Property getFileNameProperty() { result = this.getProperty("FileName") }

  /** Gets the `WorkingDirectory` property. */
  Property getWorkingDirectoryProperty() { result = this.getProperty("WorkingDirectory") }
}

/** The `System.Diagnostics.Process` class. */
class SystemDiagnosticsProcessClass extends SystemDiagnosticsClass {
  SystemDiagnosticsProcessClass() { this.hasName("Process") }

  /** Get a `Start( ...)` method. */
  Method getAStartMethod() {
    result.getDeclaringType() = this and
    result.hasName("Start") and
    result.getReturnType() instanceof SystemDiagnosticsProcessClass
  }
}

/** The `System.Diagnostics.CodeAnalysis.DoesNotReturnIfAttribute` class. */
class SystemDiagnosticsCodeAnalysisDoesNotReturnIfAttributeClass extends SystemDiagnosticsCodeAnalysisClass {
  SystemDiagnosticsCodeAnalysisDoesNotReturnIfAttributeClass() {
    this.hasName("DoesNotReturnIfAttribute")
  }
}

/** Data flow for `System.Diagnostics.ActivityTagsCollection`. */
private class SystemDiagnosticsActivityTagsCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Diagnostics;ActivityTagsCollection;false;ActivityTagsCollection;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<System.String,System.Object>>);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Diagnostics;ActivityTagsCollection;false;ActivityTagsCollection;(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<System.String,System.Object>>);;Argument[0].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue.Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Diagnostics;ActivityTagsCollection;false;Add;(System.Collections.Generic.KeyValuePair<System.String,System.Object>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Diagnostics;ActivityTagsCollection;false;Add;(System.Collections.Generic.KeyValuePair<System.String,System.Object>);;Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Value];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Diagnostics;ActivityTagsCollection;false;GetEnumerator;();;Argument[Qualifier].Element;ReturnValue.Property[System.Diagnostics.ActivityTagsCollection+Enumerator.Current];value",
      ]
  }
}

/** Data flow for `System.Diagnostics.TraceListenerCollection`. */
private class SystemDiagnosticsTraceListenerCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Diagnostics;TraceListenerCollection;false;Add;(System.Diagnostics.TraceListener);;Argument[0];Argument[Qualifier].Element;value",
        "System.Diagnostics;TraceListenerCollection;false;AddRange;(System.Diagnostics.TraceListenerCollection);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Diagnostics;TraceListenerCollection;false;AddRange;(System.Diagnostics.TraceListener[]);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Diagnostics;TraceListenerCollection;false;CopyTo;(System.Diagnostics.TraceListener[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System.Diagnostics;TraceListenerCollection;false;Insert;(System.Int32,System.Diagnostics.TraceListener);;Argument[1];Argument[Qualifier].Element;value",
        "System.Diagnostics;TraceListenerCollection;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Diagnostics;TraceListenerCollection;false;get_Item;(System.String);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Diagnostics;TraceListenerCollection;false;set_Item;(System.Int32,System.Diagnostics.TraceListener);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.Diagnostics.ProcessModuleCollection`. */
private class SystemDiagnosticsProcessModuleCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Diagnostics;ProcessModuleCollection;false;CopyTo;(System.Diagnostics.ProcessModule[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value"
  }
}

/** Data flow for `System.Diagnostics.ProcessThreadCollection`. */
private class SystemDiagnosticsProcessThreadCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Diagnostics;ProcessThreadCollection;false;Add;(System.Diagnostics.ProcessThread);;Argument[0];Argument[Qualifier].Element;value",
        "System.Diagnostics;ProcessThreadCollection;false;CopyTo;(System.Diagnostics.ProcessThread[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
      ]
  }
}
