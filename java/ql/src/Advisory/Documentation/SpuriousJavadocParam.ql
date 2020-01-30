/**
 * @name Spurious Javadoc @param tags
 * @description Javadoc @param tags that do not match any parameters in the method or constructor are confusing.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id java/unknown-javadoc-parameter
 * @tags maintainability
 */

import java

from Callable callable, ParamTag paramTag, string what, string msg
where
  callable.(Documentable).getJavadoc().getAChild() = paramTag and
  (if callable instanceof Constructor then what = "constructor" else what = "method") and
  if exists(paramTag.getParamName())
  then
    // The tag's value is neither matched by a callable parameter name ...
    not callable.getAParameter().getName() = paramTag.getParamName() and
    // ... nor by a type parameter name.
    not exists(TypeVariable tv | tv.getGenericCallable() = callable |
      "<" + tv.getName() + ">" = paramTag.getParamName()
    ) and
    msg =
      "@param tag \"" + paramTag.getParamName() + "\" does not match any actual parameter of " +
        what + " \"" + callable.getName() + "()\"."
  else
    // The tag has no value at all.
    msg = "This @param tag does not have a value."
select paramTag, msg
