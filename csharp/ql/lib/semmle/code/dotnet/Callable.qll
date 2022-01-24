/**
 * Provides `Callable` classes, which are things that can be called
 * such as methods and constructors.
 */

import Declaration
import Variable
import Expr
import Parameterizable

/** A .Net callable. */
class Callable extends Parameterizable, @dotnet_callable {
  /** Holds if this callable has a body or an implementation. */
  predicate hasBody() { none() }

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
    result = this.getReturnType().getLabel()
    or
    not exists(this.getReturnType()) and result = "System.Void"
  }

  /** Gets the return type of this callable. */
  Type getReturnType() { none() }
}

/** A constructor. */
abstract class Constructor extends Callable { }

/** A destructor/finalizer. */
abstract class Destructor extends Callable { }

pragma[nomagic]
private ValueOrRefType getARecordBaseType(ValueOrRefType t) {
  exists(Callable c |
    c.hasName("<Clone>$") and
    c.getNumberOfParameters() = 0 and
    t = c.getDeclaringType() and
    result = t
  )
  or
  result = getARecordBaseType(t).getABaseType()
}

/** A clone method on a record. */
class RecordCloneCallable extends Callable {
  RecordCloneCallable() {
    this.getDeclaringType() instanceof ValueOrRefType and
    this.hasName("<Clone>$") and
    this.getNumberOfParameters() = 0 and
    this.getReturnType() = getARecordBaseType(this.getDeclaringType()) and
    this.(Member).isPublic() and
    not this.(Member).isStatic()
  }

  /** Gets the constructor that this clone method calls. */
  Constructor getConstructor() {
    result.getDeclaringType() = this.getDeclaringType() and
    result.getNumberOfParameters() = 1 and
    result.getParameter(0).getType() = this.getDeclaringType()
  }
}
