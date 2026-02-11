/**
 * Provides a class that models parameters to functions.
 */

import semmle.code.cpp.Location
import semmle.code.cpp.Declaration
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ function parameter, catch block parameter, or requires expression parameter.
 * For example the function parameter `p` and the catch block parameter `e` in the following
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
 * For catch block parameters and expression , there is a one-to-one
 * correspondence between the `Parameter` and its `VariableDeclarationEntry`.
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
      vde = this.getANamedDeclarationEntry() and result = vde.getName()
    |
      vde.isDefinition() or not this.getANamedDeclarationEntry().isDefinition()
    )
    or
    not exists(this.getANamedDeclarationEntry()) and
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
      (
        if exists(this.getType().getName())
        then typeString = this.getType().getName()
        else typeString = ""
      ) and
      (if exists(this.getName()) then nameString = this.getName() else nameString = "") and
      (
        if typeString != "" and nameString != ""
        then result = typeString + " " + nameString
        else result = typeString + nameString
      )
    )
  }

  private VariableDeclarationEntry getANamedDeclarationEntry() {
    result = this.getAnEffectiveDeclarationEntry() and
    exists(string name | var_decls(unresolveElement(result), _, _, name, _) | name != "")
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
    if this.getFunction().isConstructedFrom(_)
    then
      exists(Function prototypeInstantiation |
        prototypeInstantiation.getParameter(this.getIndex()) = result.getVariable() and
        this.getFunction().isConstructedFrom(prototypeInstantiation)
      )
    else result = this.getADeclarationEntry()
  }

  /**
   * Holds if this parameter has a name.
   *
   * In other words, this predicate holds precisely when the result of
   * `getName()` is not "(unnamed parameter i)" (where `i` is the index
   * of the parameter).
   */
  predicate isNamed() { exists(this.getANamedDeclarationEntry()) }

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
   * Gets the requires expression to which the parameter belongs, if it is a
   * requires expression parameter.
   */
  RequiresExpr getRequiresExpr() { params(underlyingElement(this), unresolveElement(result), _, _) }

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
      vde = this.getAnEffectiveDeclarationEntry() and result = vde.getLocation()
    |
      vde.isDefinition() or not this.getAnEffectiveDeclarationEntry().isDefinition()
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
