import java

from Parameter p, Array a
where p.getType() = a and p.getFile().getBaseName() = "primitiveArrays.kt"
select p, a, a.getComponentType(), a.getElementType()
