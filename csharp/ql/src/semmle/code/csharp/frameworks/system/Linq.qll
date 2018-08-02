/**
 * Provides classes related to the namespace `System.Linq`.
 */
private import csharp as csharp
private import semmle.code.csharp.frameworks.System as System

module SystemLinq {

  /** The `System.Linq` namespace. */
  class Namespace extends csharp::Namespace {
    Namespace() {
      this.getParentNamespace() instanceof System::SystemNamespace and
      this.hasName("Linq")
    }
  }

  /** A class in the `System.Linq` namespace. */
  class Class extends csharp::Class {
    Class() {
      this.getNamespace() instanceof Namespace
    }
  }
}
