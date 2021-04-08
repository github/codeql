/**
 * Provides a class that models parameters to functions.
 */

import semmle.code.cpp.Location
import semmle.code.cpp.Declaration
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ function parameter or catch block parameter. For example the
 * function parameter `p` and the catch block parameter `e` in the following
 * code:
 * ```
 * void myFunction(int p) {
 *   try {
 *     ...
 *   } catch (const std::exception &e) {
 *     ...
 *   }
 * }
 * ```
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
   * Gets the canonical name, or names, of this parameter.
   *
   * The canonical names are the first non-empty category from the
   * following list:
   *  1. The name given to the parameter at the function's definition or
   *     (for catch block parameters) at the catch block.
   *  2. A name given to the parameter at a function declaration.
   *  3. The name "(unnamed parameter i)" where i is the index of the parameter.
   */
  override string getName() {
    exists(VariableDeclarationEntry vde |
      vde = getANamedDeclarationEntry() and result = vde.getName()
    |
      vde.isDefinition() or not getANamedDeclarationEntry().isDefinition()
    )
    or
    not exists(getANamedDeclarationEntry()) and
    result = "(unnamed parameter " + this.getIndex().toString() + ")"
  }

  override string getAPrimaryQlClass() { result = "Parameter" }

  /**
   * Gets the name of this parameter, including it's type.
   *
   * For example: `int p`.
   */
  string getTypedName() {
    exists(string typeString, string nameString |
      (if exists(getType().getName()) then typeString = getType().getName() else typeString = "") and
      (if exists(getName()) then nameString = getName() else nameString = "") and
      (
        if typeString != "" and nameString != ""
        then result = typeString + " " + nameString
        else result = typeString + nameString
      )
    )
  }

  private VariableDeclarationEntry getANamedDeclarationEntry() {
    result = getAnEffectiveDeclarationEntry() and result.getName() != ""
  }

  /**
   * Gets a declaration entry corresponding to this declaration.
   *
   * This predicate is the same as getADeclarationEntry(), except that for
   * parameters of instantiated function templates, gives the declaration
   * entry of the prototype instantiation of the parameter (as
   * non-prototype instantiations don't have declaration entries of their
   * own).
   */
  private VariableDeclarationEntry getAnEffectiveDeclarationEntry() {
    if getFunction().isConstructedFrom(_)
    then
      exists(Function prototypeInstantiation |
        prototypeInstantiation.getParameter(getIndex()) = result.getVariable() and
        getFunction().isConstructedFrom(prototypeInstantiation)
      )
    else result = getADeclarationEntry()
  }

  /**
   * Gets the name of this parameter in the given block (which should be
   * the body of a function with which the parameter is associated).
   *
   * DEPRECATED: this method was used in a previous implementation of
   * getName, but is no longer in use.
   */
  deprecated string getNameInBlock(BlockStmt b) {
    exists(ParameterDeclarationEntry pde |
      pde.getFunctionDeclarationEntry().getBlock() = b and
      this.getFunction().getBlock() = b and
      pde.getVariable() = this and
      result = pde.getName()
    )
  }

  /**
   * Holds if this parameter has a name.
   *
   * In other words, this predicate holds precisely when the result of
   * `getName()` is not "(unnamed parameter i)" (where `i` is the index
   * of the parameter).
   */
  predicate isNamed() { exists(getANamedDeclarationEntry()) }

  /**
   * Gets the function to which this parameter belongs, if it is a function
   * parameter.
   */
  override Function getFunction() {
    params(underlyingElement(this), unresolveElement(result), _, _)
  }

  /**
   * Gets the catch block to which this parameter belongs, if it is a catch
   * block parameter.
   */
  BlockStmt getCatchBlock() { params(underlyingElement(this), unresolveElement(result), _, _) }

  /**
   * Gets the zero-based index of this parameter.
   *
   * For catch block parameters, this is always zero.
   */
  int getIndex() { params(underlyingElement(this), _, result, _) }

  /**
   * Gets the type of this parameter.
   *
   * Function parameters of array type are a special case in C/C++,
   * as they are syntactic sugar for parameters of pointer type. The
   * result is an array type for such parameters.
   */
  override Type getType() { params(underlyingElement(this), _, _, unresolveElement(result)) }

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
      vde = getAnEffectiveDeclarationEntry() and result = vde.getLocation()
    |
      vde.isDefinition() or not getAnEffectiveDeclarationEntry().isDefinition()
    )
  }
}

/**
 * An `int` that is a parameter index for some function.  This is needed for binding in certain cases.
 */
class ParameterIndex extends int {
  ParameterIndex() {
    exists(Parameter p | this = p.getIndex()) or
    exists(Call c | exists(c.getArgument(this))) or // permit indexing varargs
    this = -1 // used for `this`
  }
}
