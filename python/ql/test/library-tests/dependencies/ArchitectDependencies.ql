
import python
import Architect.Common.DependencyCategory
import Architect.Architect

from DependencyCategory dk, DependencyElement source, DependencyElement target, DependencyElement cause
where dk.isADependency(source, target, cause)
select dk.toString(), source.toString(), target.toString(), cause.toString()

