/**
 * @name Definitions
 * @description Jump to definition helper query.
 * @kind definitions
 * @id rb/jump-to-definition
 */

/*
 * TODO:
 *    - instance and class variables
 *    - should `Foo.new` point to `Foo#initialize`?
 */

import ruby
import codeql_ruby.ast.internal.Module
import codeql_ruby.dataflow.SSA

from DefLoc loc, Expr src, Expr target, string kind
where
  ConstantDefLoc(src, target) = loc and kind = "constant"
  or
  LocalMethodLoc(src, target) = loc and kind = "method"
  or
  LocalVariableLoc(src, target) = loc and kind = "variable"
select src, target, kind

/**
 * Definition location info for different identifiers.
 * Each branch holds two values that are subclasses of `Expr`.
 * The first is the "source" - some usage of an identifier.
 * The second is the "target" - the definition of that identifier.
 */
newtype DefLoc =
  /** A constant, module or class. */
  ConstantDefLoc(ConstantReadAccess read, ConstantWriteAccess write) { write = definitionOf(read) } or
  /** A call to a method that is defined in the same class as the call. */
  LocalMethodLoc(MethodCall call, Method meth) {
    meth = lookupMethod(call.getEnclosingModule().getModule(), call.getMethodName()) and
    call.getReceiver() instanceof Self
  } or
  /** A local variable. */
  LocalVariableLoc(VariableReadAccess read, VariableWriteAccess write) {
    exists(Ssa::WriteDefinition w |
      write = w.getWriteAccess() and
      read = w.getARead().getExpr() and
      not read.getLocation() = write.getLocation()
    )
  }

/**
 * Gets the fully qualified name for a constant, based on the context in which it is defined.
 *
 *  For example, given
 *  ```ruby
 *  module Foo
 *    module Bar
 *      class Baz
 *      end
 *    end
 *  end
 *  ```
 *
 *  the constant `Baz` has the fully qualified name `Foo::Bar::Baz`.
 */
string constantQualifiedName(ConstantWriteAccess w) {
  not exists(ConstantWriteAccess w2 | w2.getAChild() = w) and result = w.getName()
  or
  exists(ConstantWriteAccess w2 |
    w2.getAChild() = w and result = constantQualifiedName(w2) + "::" + w.getName()
  )
}

/**
 * Gets the constant write that defines the given constant.
 *  Modules often don't have a unique definition, as they are opened multiple times in different
 *  files. In these cases we arbitrarily pick the definition with the lexicographically least
 *  location.
 */
ConstantWriteAccess definitionOf(ConstantReadAccess r) {
  result =
    max(ConstantWriteAccess w |
      TResolved(constantQualifiedName(w)) = resolveScopeExpr(r)
    |
      w order by w.getLocation().toString()
    )
}
