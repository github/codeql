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

  override Callable getSourceDeclaration() {
    result = Declaration.super.getSourceDeclaration()
  }

  /** Gets the number of parameters of this callable. */
  int getNumberOfParameters() { result = count(getAParameter()) }

  /** Gets a parameter, if any. */
  Parameter getAParameter() { result = getParameter(_) }

  /** Gets a raw parameter (including the qualifier), if any. */
  final Parameter getARawParameter() { result = getRawParameter(_) }

  /** Holds if this callable can return expression `e`. */
  predicate canReturn(Expr e) { none() }

  final override string getLabel() {
    result = getReturnTypeLabel() + " " + getDeclaringType().getLabel() + "." + getUndecoratedName() +
      getGenericsLabel(this) + getMethodParams()
  }

  private string getReturnTypeLabel() {
    if exists(getReturnType())
    then result = getReturnType().getLabel()
    else result = "System.Void"
  }

  private string getMethodParams() { result = "(" + getMethodParamList() + ")" }

  language [monotonicAggregates]
  private string getMethodParamList() {
    result = concat(int p | exists(getParameter(p)) | getParameter(p).getType().getLabel(), "," order by p)
  }

  override string getUndecoratedName() { result=getName() }

  /** Gets the return type of this callable. */
  Type getReturnType() { none() }
}

/** A constructor. */
abstract class Constructor extends Callable {
}

/** A destructor/finalizer. */
abstract class Destructor extends Callable {
}
