import powershell

abstract private class AbstractObjectCreation extends CallExpr {
  /** The name of the type of the object being constructed. */
  abstract string getConstructedTypeName();

  abstract Expr getConstructedTypeExpr();
}

/**
 * An object creation from a call to a constructor. For example:
 * ```powershell
 * [System.IO.FileInfo]::new("C:\\file.txt")
 * ```
 */
class NewObjectCreation extends AbstractObjectCreation, ConstructorCall {
  final override string getConstructedTypeName() {
    result = ConstructorCall.super.getConstructedTypeName()
  }

  final override Expr getConstructedTypeExpr() { result = typename }
}

/**
 * An object creation from a call to `New-Object`. For example:
 * ```powershell
 * New-Object -TypeName System.IO.FileInfo -ArgumentList "C:\\file.txt"
 * ```
 */
class DotNetObjectCreation extends AbstractObjectCreation, CmdCall {
  DotNetObjectCreation() { this.getLowerCaseName() = "new-object" }

  final override string getConstructedTypeName() {
    result = this.getConstructedTypeExpr().(StringConstExpr).getValueString()
  }

  final override Expr getConstructedTypeExpr() {
    // Either it's the named argument `TypeName`
    result = CmdCall.super.getNamedArgument("TypeName")
    or
    // Or it's the first positional argument if that's the named argument
    not CmdCall.super.hasNamedArgument("TypeName") and
    result = CmdCall.super.getPositionalArgument(0) and
    result = CmdCall.super.getNamedArgument(["ArgumentList", "Property"])
  }
}

final class ObjectCreation = AbstractObjectCreation;
