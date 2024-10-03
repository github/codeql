import powershell

abstract private class AbstractObjectCreation extends Call {
  /**
   * The type of the object being constructed.
   * Note that the type may not exist in the database.
   *
   * Use `getConstructedTypeName` to get the name of the type (which will
   * always exist in the database).
   */
  abstract Type getConstructedType();

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
  final override Type getConstructedType() { result = ConstructorCall.super.getConstructedType() }

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
class DotNetObjectCreation extends AbstractObjectCreation instanceof Cmd {
  DotNetObjectCreation() { this.getCommandName() = "New-Object" }

  final override Type getConstructedType() { none() }

  final override string getConstructedTypeName() {
    // Either it's the named argument `TypeName`
    result = Cmd.super.getNamedArgument("TypeName").(StringConstExpr).getValue().getValue()
    or
    // Or it's the first positional argument if that's the named argument
    not Cmd.super.hasNamedArgument("TypeName") and
    exists(StringConstExpr arg | arg = Cmd.super.getPositionalArgument(0) |
      result = arg.getValue().getValue() and
      not arg = Cmd.super.getNamedArgument(["ArgumentList", "Property"])
    )
  }
}

final class ObjectCreation = AbstractObjectCreation;
