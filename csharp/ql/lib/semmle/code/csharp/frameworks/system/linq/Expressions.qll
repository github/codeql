/**
 * Provides classes related to the namespace `System.Linq.Expressions`.
 */

private import csharp as CSharp
private import semmle.code.csharp.frameworks.system.Linq

/** Definitions relating to the `System.Linq.Expressions` namespace. */
module SystemLinqExpressions {
  /** The `System.Linq.Expressions` namespace. */
  class Namespace extends CSharp::Namespace {
    Namespace() {
      this.getParentNamespace() instanceof SystemLinq::Namespace and
      this.hasName("Expressions")
    }
  }

  /** A class in the `System.Linq.Expressions` namespace. */
  class Class extends CSharp::Class {
    Class() { this.getNamespace() instanceof Namespace }
  }

  /** The `Expression<TDelegate>` class. */
  class ExpressionDelegate extends Class, CSharp::UnboundGenericClass {
    ExpressionDelegate() { this.hasName("Expression<>") }
  }

  /**
   * An extended `delegate` type. Either an actual `delegate` type,
   * or a type of the form `Expression<T>`, where `T` is an actual
   * `delegate` type.
   */
  class DelegateExtType extends CSharp::Type {
    CSharp::DelegateType dt;

    DelegateExtType() {
      this = dt
      or
      this =
        any(CSharp::ConstructedClass cc |
          cc.getUnboundGeneric() instanceof ExpressionDelegate and
          dt = cc.getTypeArgument(0)
        )
    }

    /** Gets the underlying `delegate` type. */
    CSharp::DelegateType getDelegateType() { result = dt }
  }
}
