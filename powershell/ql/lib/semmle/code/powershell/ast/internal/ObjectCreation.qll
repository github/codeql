import powershell

abstract private class AbstractObjectCreation extends CallExpr {
  /** The name of the type of the object being constructed. */
  abstract string getConstructedTypeName();
}

/**
 * An object creation from a call to a constructor. For example:
 * ```powershell
 * [System.IO.FileInfo]::new("C:\\file.txt")
 * ```
 */
class NewObjectCreation extends AbstractObjectCreation instanceof ConstructorCall {
  final override string getConstructedTypeName() {
    result = ConstructorCall.super.getConstructedTypeName()
  }
}

/**
 * An object creation from a call to `New-Object`. For example:
 * ```powershell
 * New-Object -TypeName System.IO.FileInfo -ArgumentList "C:\\file.txt"
 * ```
 */
class DotNetObjectCreation extends AbstractObjectCreation instanceof CmdCall {
  DotNetObjectCreation() { this.getName() = "New-Object" }

  final override string getConstructedTypeName() {
    // Either it's the named argument `TypeName`
    result = CmdCall.super.getNamedArgument("TypeName").(StringConstExpr).getValueString()
    or
    // Or it's the first positional argument if that's the named argument
    not CmdCall.super.hasNamedArgument("TypeName") and
    exists(StringConstExpr arg | arg = CmdCall.super.getPositionalArgument(0) |
      result = arg.getValueString() and
      not arg = CmdCall.super.getNamedArgument(["ArgumentList", "Property"])
    )
  }
}

final class ObjectCreation = AbstractObjectCreation;
