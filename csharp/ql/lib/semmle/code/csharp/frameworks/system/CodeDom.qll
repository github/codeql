/** Provides definitions related to the namespace `System.CodeDom`. */

import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.dataflow.ExternalFlow

/** The `System.CodeDome` namespace. */
class SystemCodeDomNamespace extends Namespace {
  SystemCodeDomNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("CodeDom")
  }
}
