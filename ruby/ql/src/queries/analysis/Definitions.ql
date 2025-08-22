/**
 * @name Definitions
 * @description Jump to definition helper query.
 * @kind definitions
 * @id rb/jump-to-definition
 */

/*
 * TODO:
 *    - should `Foo.new` point to `Foo#initialize`?
 */

import codeql.ruby.AST
import codeql.ruby.dataflow.SSA
import codeql.ruby.dataflow.internal.DataFlowDispatch

from DefLoc loc, Expr src, Expr target, string kind
where
  ConstantDefLoc(src, target) = loc and kind = "constant"
  or
  MethodLoc(src, target) = loc and kind = "method"
  or
  LocalVariableLoc(src, target) = loc and kind = "variable"
  or
  InstanceVariableLoc(src, target) = loc and kind = "instance variable"
  or
  ClassVariableLoc(src, target) = loc and kind = "class variable"
select src, target, kind

/**
 * Definition location info for different identifiers.
 * Each branch holds two values that are subclasses of `Expr`.
 * The first is the "source" - some usage of an identifier.
 * The second is the "target" - the definition of that identifier.
 */
newtype DefLoc =
  /** A constant, module or class. */
  ConstantDefLoc(ConstantReadAccess read, ConstantWriteAccess write) {
    write = definitionOf(read.getAQualifiedName())
  } or
  /** A method call. */
  MethodLoc(MethodCall call, Method meth) {
    meth = call.getATarget()
    or
    // include implicit `initialize` calls
    meth = getInitializeTarget(call.getAControlFlowNode())
  } or
  /** A local variable. */
  LocalVariableLoc(VariableReadAccess read, VariableWriteAccess write) {
    exists(Ssa::WriteDefinition w |
      write = w.getWriteAccess().getAstNode() and
      read = w.getARead().getExpr() and
      not read.isSynthesized()
    )
  } or
  /** An instance variable */
  InstanceVariableLoc(InstanceVariableReadAccess read, InstanceVariableWriteAccess write) {
    /*
     * We consider instance variables to be "defined" in the initialize method of their enclosing class.
     * If that method doesn't exist, we won't provide any jump-to-def information for the instance variable.
     */

    exists(Method m |
      m.getAChild+() = write and
      m.getName() = "initialize" and
      write.getVariable() = read.getVariable()
    )
  } or
  /** A class variable */
  ClassVariableLoc(ClassVariableReadAccess read, ClassVariableWriteAccess write) {
    read.getVariable() = write.getVariable() and
    not exists(MethodBase m | m.getAChild+() = write)
  }

/**
 * Gets the constant write that defines the given constant.
 *  Modules often don't have a unique definition, as they are opened multiple times in different
 *  files. In these cases we arbitrarily pick the definition with the lexicographically least
 *  location.
 */
pragma[noinline]
ConstantWriteAccess definitionOf(string fqn) {
  fqn = any(ConstantReadAccess read).getAQualifiedName() and
  result =
    min(ConstantWriteAccess w, Location l |
      w.getAQualifiedName() = fqn and l = w.getLocation()
    |
      w
      order by
        l.getFile().getAbsolutePath(), l.getStartLine(), l.getStartColumn(), l.getEndLine(),
        l.getEndColumn()
    )
}
