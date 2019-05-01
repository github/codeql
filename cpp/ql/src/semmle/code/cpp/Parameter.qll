import semmle.code.cpp.Location
import semmle.code.cpp.Declaration
private import semmle.code.cpp.internal.ResolveClass
private import semmle.code.cpp.internal.QualifiedName as Q

/**
 * A C/C++ function parameter or catch block parameter.
 *
 * For catch block parameters, there is a one-to-one correspondence between
 * the `Parameter` and its `ParameterDeclarationEntry`.
 *
 * For function parameters, there is a one-to-many relationship between
 * `Parameter` and `ParameterDeclarationEntry`, because one function can
 * have multiple declarations.
 */
class Parameter extends LocalScopeVariable, @parameter {
  /**
   * Gets the name of this parameter, including it's type.
   *
   * For example: `int p`.
   */
  string getTypedName() {
    exists (string typeString, string nameString
    | (if exists(getType().getName())
         then typeString = getType().getName()
         else typeString = "")
      and
      (if exists(getName())
         then nameString = getName()
         else nameString = "")
      and
      (if typeString != "" and nameString != ""
         then result = typeString + " " + nameString
         else result = typeString + nameString))
  }

  /**
   * Gets the name of this parameter in the given block (which should be
   * the body of a function with which the parameter is associated).
   *
   * DEPRECATED: this method was used in a previous implementation of
   * getName, but is no longer in use.
   */
  deprecated string getNameInBlock(Block b) {
    exists (ParameterDeclarationEntry pde
    | pde.getFunctionDeclarationEntry().getBlock() = b and
      this.getFunction().getBlock() = b and
      pde.getVariable() = this and
      result = pde.getName())
  }

  /**
   * Holds if this parameter has a name.
   *
   * In other words, this predicate holds precisely when the result of
   * `getName()` is not "p#i" (where `i` is the index of the parameter).
   */
  predicate isNamed() { exists(this.(Q::Parameter).getANamedDeclarationEntry()) }

  /**
   * Gets the function to which this parameter belongs, if it is a function
   * parameter.
   */
  override Function getFunction() { params(underlyingElement(this),unresolveElement(result),_,_) }

  /**
   * Gets the catch block to which this parameter belongs, if it is a catch
   * block parameter.
   */
  Block getCatchBlock() { params(underlyingElement(this),unresolveElement(result),_,_) }

  /**
   * Gets the zero-based index of this parameter.
   *
   * For catch block parameters, this is always zero.
   */
  int getIndex() { params(underlyingElement(this),_,result,_) }

  /**
   * Gets the type of this parameter.
   *
   * Function parameters of array type are a special case in C/C++,
   * as they are syntactic sugar for parameters of pointer type. The
   * result is an array type for such parameters.
   */
  override Type getType() { params(underlyingElement(this),_,_,unresolveElement(result)) }

  /**
   * Gets the canonical location, or locations, of this parameter.
   *
   * 1. For catch block parameters, gets the obvious location.
   * 2. For parameters of functions which have a definition, gets the
   *    location within the function definition.
   * 3. For parameters of functions which don't have a definition, gets all
   *    of the declaration locations.
   */
  override Location getLocation() {
    exists(VariableDeclarationEntry vde |
      vde = this.(Q::Parameter).getAnEffectiveDeclarationEntry() and
      result = vde.getLocation()
    |
      vde.isDefinition()
      or
      not this.(Q::Parameter).getAnEffectiveDeclarationEntry().isDefinition()
    )
  }
}
