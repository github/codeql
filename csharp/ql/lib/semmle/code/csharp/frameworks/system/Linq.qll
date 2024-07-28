/**
 * Provides classes related to the namespace `System.Linq`.
 */

private import csharp as CSharp
private import semmle.code.csharp.frameworks.System as System

/** Definitions relating to the `System.Linq` namespace. */
module SystemLinq {
  /** The `System.Linq` namespace. */
  class Namespace extends CSharp::Namespace {
    Namespace() {
      this.getParentNamespace() instanceof System::SystemNamespace and
      this.hasUndecoratedName("Linq")
    }
  }

  /** A class in the `System.Linq` namespace. */
  class Class extends CSharp::Class {
    Class() { this.getNamespace() instanceof Namespace }
  }

  /** The `System.Linq.Enumerable` class. */
  class SystemLinqEnumerableClass extends Class {
    SystemLinqEnumerableClass() { this.hasName("Enumerable") }

    /** Gets a `Count()` method. */
    CSharp::ExtensionMethod getACountMethod() { result = this.getAMethod("Count`1") }

    /** Gets an `Any()` method. */
    CSharp::ExtensionMethod getAnAnyMethod() { result = this.getAMethod("Any`1") }
  }
}
