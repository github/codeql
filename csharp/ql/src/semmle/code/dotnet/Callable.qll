/**
 * Provides `Callable` classes, which are things that can be called
 * such as methods and constructors.
 */

import Declaration
import Variable
import Expr

/** A .Net callable. */
class Callable extends Declaration, @dotnet_callable {
  /** Gets raw parameter `i`, including the `this` parameter at index 0. */
  Parameter getRawParameter(int i) { none() }

  /** Gets the `i`th parameter, excluding the `this` parameter. */
  Parameter getParameter(int i) { none() }

  /** Holds if this callable has a body or an implementation. */
  predicate hasBody() { none() }

  override Callable getSourceDeclaration() { result = Declaration.super.getSourceDeclaration() }

  /** Gets the number of parameters of this callable. */
  int getNumberOfParameters() { result = count(getAParameter()) }

  /** Gets a parameter, if any. */
  Parameter getAParameter() { result = getParameter(_) }

  /** Gets a raw parameter (including the qualifier), if any. */
  final Parameter getARawParameter() { result = getRawParameter(_) }

  /** Holds if this callable can return expression `e`. */
  predicate canReturn(Expr e) { none() }

  pragma[noinline]
  private string getDeclaringTypeLabel() { result = this.getDeclaringType().getLabel() }

  pragma[noinline]
  private string getParameterTypeLabelNonGeneric(int p) {
    not this instanceof Generic and
    result = this.getParameter(p).getType().getLabel()
  }

  language[monotonicAggregates]
  pragma[nomagic]
  private string getMethodParamListNonGeneric() {
    result =
      concat(int p |
        p in [0 .. this.getNumberOfParameters() - 1]
      |
        this.getParameterTypeLabelNonGeneric(p), "," order by p
      )
  }

  pragma[noinline]
  private string getParameterTypeLabelGeneric(int p) {
    this instanceof Generic and
    result = this.getParameter(p).getType().getLabel()
  }

  language[monotonicAggregates]
  pragma[nomagic]
  private string getMethodParamListGeneric() {
    result =
      concat(int p |
        p in [0 .. this.getNumberOfParameters() - 1]
      |
        this.getParameterTypeLabelGeneric(p), "," order by p
      )
  }

  pragma[noinline]
  private string getLabelNonGeneric() {
    not this instanceof Generic and
    result =
      this.getReturnTypeLabel() + " " + this.getDeclaringTypeLabel() + "." +
        this.getUndecoratedName() + "(" + this.getMethodParamListNonGeneric() + ")"
  }

  pragma[noinline]
  private string getLabelGeneric() {
    result =
      this.getReturnTypeLabel() + " " + this.getDeclaringTypeLabel() + "." +
        this.getUndecoratedName() + getGenericsLabel(this) + "(" + this.getMethodParamListGeneric() +
        ")"
  }

  final override string getLabel() {
    result = this.getLabelNonGeneric() or
    result = this.getLabelGeneric()
  }

  private string getReturnTypeLabel() {
    result = getReturnType().getLabel()
    or
    not exists(this.getReturnType()) and result = "System.Void"
  }

  override string getUndecoratedName() { result = getName() }

  /** Gets the return type of this callable. */
  Type getReturnType() { none() }
}

/** A constructor. */
abstract class Constructor extends Callable { }

/** A destructor/finalizer. */
abstract class Destructor extends Callable { }
