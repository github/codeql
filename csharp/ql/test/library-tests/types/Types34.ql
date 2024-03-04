import csharp

from Method m, ArrayType t1, ArrayType t2
where
  m.getName() = "ArrayArrayType" and
  m.getReturnType() = t1 and
  t1.getDimension() = 2 and
  t1.getElementType() = t2 and
  t2.getDimension() = 1 and
  t2.getElementType().(Class).hasFullyQualifiedName("Types", "Class")
select t1, t2
