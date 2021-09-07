/**
 * Provides classes related to the namespace `System.Linq.Expressions`.
 */

private import csharp as csharp
private import semmle.code.csharp.frameworks.system.Linq

/** Definitions relating to the `System.Linq.Expressions` namespace. */
module SystemLinqExpressions {
  /** The `System.Linq.Expressions` namespace. */
  class Namespace extends csharp::Namespace {
    Namespace() {
      this.getParentNamespace() instanceof SystemLinq::Namespace and
      this.hasName("Expressions")
    }
  }

  /** A class in the `System.Linq.Expressions` namespace. */
  class Class extends csharp::Class {
    Class() { this.getNamespace() instanceof Namespace }
  }

  /** The `Expression<TDelegate>` class. */
  class ExpressionDelegate extends Class, csharp::UnboundGenericClass {
    ExpressionDelegate() { this.hasName("Expression<>") }
  }

  /**
   * An extended `delegate` type. Either an actual `delegate` type,
   * or a type of the form `Expression<T>`, where `T` is an actual
   * `delegate` type.
   */
  class DelegateExtType extends csharp::Type {
    csharp::DelegateType dt;

    DelegateExtType() {
      this = dt
      or
      this =
        any(csharp::ConstructedClass cc |
          cc.getUnboundGeneric() instanceof ExpressionDelegate and
          dt = cc.getTypeArgument(0)
        )
    }

    /** Gets the underlying `delegate` type. */
    csharp::DelegateType getDelegateType() { result = dt }
  }
}
