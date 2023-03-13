/** Provides definitions related to the namespace `System.Diagnostics`. */

import semmle.code.csharp.Type
private import semmle.code.csharp.frameworks.System

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
class SystemDiagnosticsCodeAnalysisDoesNotReturnIfAttributeClass extends SystemDiagnosticsCodeAnalysisClass
{
  SystemDiagnosticsCodeAnalysisDoesNotReturnIfAttributeClass() {
    this.hasName("DoesNotReturnIfAttribute")
  }
}
