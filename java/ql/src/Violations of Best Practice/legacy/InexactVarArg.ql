/**
 * @name Inexact type match for varargs argument
 * @description Calling a varargs method where it is unclear whether the arguments
 *              should be interpreted as a list of arguments or as a single argument, may lead
 *              to compiler-dependent behavior.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/inexact-varargs
 * @tags reliability
 */

import java

predicate varArgsMethod(Method method, Array varargsType, int arity) {
  exists(MethodCall access |
    access.getMethod() = method and
    arity = method.getNumberOfParameters() and
    not access.getNumArgument() = arity and
    method.getParameterType(arity - 1) = varargsType
  )
}

RefType normalised(Type type) {
  type.(RawType).getErasure() = result
  or
  type.(ParameterizedType).getErasure() = result
  or
  type.(BoundedType).getUpperBoundType() = result
  or
  not type instanceof RawType and not type instanceof ParameterizedType and type = result
}

predicate equivalent(Array declared, Array used) {
  normalised(declared.getElementType()) = normalised(used.getElementType()) and
  declared.getDimension() = used.getDimension()
}

from Method target, MethodCall access, Array declaredType, Array usedType, int params
where
  varArgsMethod(target, declaredType, params) and
  target = access.getMethod() and
  access.getNumArgument() = params and
  usedType = access.getArgument(params - 1).getType() and
  not equivalent(declaredType, usedType) and
  declaredType.getDimension() != usedType.getDimension() + 1
select access.getArgument(params - 1),
  "Call to varargs method $@ with inexact argument type (compiler dependent).", target,
  target.getName()
