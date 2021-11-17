import java

from Class c, Type superType, Location stLocation
where c.fromSource() and
superType = c.getASupertype() and
stLocation = superType.getLocation()
select c, superType.toString(), stLocation.getFile().getBaseName(), stLocation.getStartLine(), stLocation.getStartColumn(), stLocation.getEndLine(), stLocation.getEndColumn()

