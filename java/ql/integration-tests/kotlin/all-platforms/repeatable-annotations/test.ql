import java

from ClassOrInterface annotated, Annotation a, string valName, Expr val
where
  a.getValue(valName) = val and
  annotated = a.getAnnotatedElement() and
  annotated.getName() in [
      "JavaDefinedRepeatable", "JavaDefinedContainer", "KtDefinedContainer", "LibRepeatable",
      "ExplicitContainerRepeatable", "LocalRepeatable", "User", "JavaUser"
    ]
select a.getAnnotatedElement(), a, valName, val
