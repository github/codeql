/** Provides definitions related to the namespace `System.CodeDom.Compiler`. */

import csharp
private import semmle.code.csharp.frameworks.system.CodeDom

/** The `System.CodeDom.Compiler` namespace. */
class SystemCodeDomCompilerNamespace extends Namespace {
  SystemCodeDomCompilerNamespace() {
    this.getParentNamespace() instanceof SystemCodeDomNamespace and
    this.hasName("Compiler")
  }
}

/** A reference type in the `System.CodeDom.Compiler` namespace. */
class SystemCodeDomCompilerClass extends RefType {
  SystemCodeDomCompilerClass() { this.getNamespace() instanceof SystemCodeDomCompilerNamespace }
}

/** The `System.CodeDom.Compiler.GeneratedCodeAttribute` class. */
class SystemCodeDomCompilerGeneratedCodeAttributeClass extends SystemCodeDomCompilerClass {
  SystemCodeDomCompilerGeneratedCodeAttributeClass() { this.hasName("GeneratedCodeAttribute") }
}

/** The `System.CodeDom.Compiler.ICodeCompiler` class. */
class SystemCodeDomCompilerICodeCompilerClass extends SystemCodeDomCompilerClass {
  SystemCodeDomCompilerICodeCompilerClass() { this.hasName("ICodeCompiler") }
}
