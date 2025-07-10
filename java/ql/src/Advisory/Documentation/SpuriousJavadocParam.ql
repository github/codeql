/**
 * @name Spurious Javadoc @param tags
 * @description Javadoc @param tags that do not match any parameters in the method or constructor or
 *              any type parameters of the annotated class are confusing.
 * @kind problem
 * @problem.severity recommendation
 * @precision very-high
 * @id java/unknown-javadoc-parameter
 * @tags maintainability
 */

import java

from Documentable documentable, ParamTag paramTag, string msg
where
  documentable.getJavadoc().getAChild() = paramTag and
  if exists(paramTag.getParamName())
  then
    documentable instanceof Callable and
    exists(string what |
      if documentable instanceof Constructor then what = "constructor" else what = "method"
    |
      // The tag's value is neither matched by a callable parameter name ...
      not documentable.(Callable).getAParameter().getName() = paramTag.getParamName() and
      // ... nor by a type parameter name.
      not exists(TypeVariable tv | tv.getGenericCallable() = documentable |
        "<" + tv.getName() + ">" = paramTag.getParamName()
      ) and
      msg =
        "@param tag \"" + paramTag.getParamName() + "\" does not match any actual parameter of " +
          what + " \"" + documentable.getName() + "()\"."
    )
    or
    documentable instanceof ClassOrInterface and
    not documentable instanceof Record and
    not exists(TypeVariable tv | tv.getGenericType() = documentable |
      "<" + tv.getName() + ">" = paramTag.getParamName()
    ) and
    msg =
      "@param tag \"" + paramTag.getParamName() +
        "\" does not match any actual type parameter of type \"" + documentable.getName() + "\"."
    or
    documentable instanceof Record and
    not exists(TypeVariable tv | tv.getGenericType() = documentable |
      "<" + tv.getName() + ">" = paramTag.getParamName()
    ) and
    not documentable.(Record).getCanonicalConstructor().getAParameter().getName() =
      paramTag.getParamName() and
    msg =
      "@param tag \"" + paramTag.getParamName() +
        "\" does not match any actual type parameter or record parameter of record \"" +
        documentable.getName() + "\"."
  else
    // The tag has no value at all.
    msg = "This @param tag does not have a value."
select paramTag, msg
